<%@ WebHandler Language="C#" Class="search_report" %>
using System;
using System.Web;
using System.IO;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;
public class search_report : IHttpHandler
{
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string search_value = "";
    public void ProcessRequest(HttpContext context)
    {
        mContext = context;
        try
        {
            string key = context.Request.Form["key"];
            string body = context.Request.Form["body"].Trim();
            try
            {
                result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
                string json = AES.Decrypt(body, result, "");
                string[] str = json.Split('#');
                JObject obj = JObject.Parse(str[0]);
                search_value = obj["search_value"].ToString();
            }
            catch (Exception ex)
            {

                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }
            db.Connect();
            getReport();
        }
        catch (Exception ex)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60057");
        }
        finally
        {
            string res = AES.Encrypt(resopnse, result, "");
            context.Response.Write(res);
            db.Close();
        }
    }
    /// <summary>
    /// 分组查询
    /// SELECT  COUNT(*) AS COUNT, PRODUCT_NO ,PRODUCT_IMAGE1,PRODUCT_NAME FROM TBL_PRODUCT_FEEDBACK GROUP BY PRODUCT_NO,PRODUCT_IMAGE1 ,PRODUCT_NAME
    /// </summary>
    private void getReport()
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT_FEEDBACK");
        query.AddColumn("COUNT(*) AS COUNT");
        query.AddColumn("PRODUCT_NO");
        query.AddColumn("PRODUCT_IMAGE1");
        query.AddColumn("PRODUCT_NAME");
        query.AddColumn("PRODUCT_CATEGORY_NAME");
        query.SetGroup("PRODUCT_NO,PRODUCT_IMAGE1,PRODUCT_NAME,PRODUCT_CATEGORY_NAME");
        string strConditions =
                "(PRODUCT_NAME  LIKE '%" + search_value + "%' OR PRODUCT_CATEGORY_NAME LIKE '%" + search_value + "%')";
        query.AddCondition(strConditions);
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        JsonUtil.setJson4(strResult, "product_report", "[");
        foreach (DataRow dr in drc)
        {
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "product_img", ImgPath.base_product_path + dr["PRODUCT_NO"] + "/" + dr["PRODUCT_IMAGE1"].ToString().Trim());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_name", dr["PRODUCT_NAME"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "count", dr["COUNT"].ToString());
            strResult.Append("}");
            if (drc.IndexOf(dr) != drc.Count - 1)
            {
                strResult.Append(",");
            }
        }
        strResult.Append("]");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}