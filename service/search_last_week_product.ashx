<%@ WebHandler Language="C#" Class="search_last_week_product" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;


public class search_last_week_product : IHttpHandler
{
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    public void ProcessRequest(HttpContext context)
    {
        string key = context.Request.Form["key"];
        try
        {
            try
            {
                result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
            }
            catch
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }
            db.Connect();
            getProduct_List();
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
    /// 获取上周商品
    /// </summary>
    public void getProduct_List()
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT");
        query.AddColumn("*");
        query.AddCondition("PRODUCT_EVAL_STATE='1'");
        query.AddCondition("PRODUCT_EVAL_WEEKS=" + (int.Parse(TimeUtils.WeekOfYear(DateTime.Now)) - 1));
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        JsonUtil.setJson4(strResult, "product_list_week", "[");
        foreach (DataRow dr in drc)
        {
            //上周
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "img_url", ImgPath.base_product_path + dr["PRODUCT_CODE"] + "/" + dr["PRODUCT_IMAGE1"].ToString().Trim());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_id", dr["PRODUCT_CODE"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_name", dr["PRODUCT_NAME"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "recommend_season", dr["PRODUCT_DESC"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "cash_state", dr["PRODUCT_EVAL_DEPOSIT_REFUND_RATE"].ToString());
            strResult.Append("}");
            if (drc.IndexOf(dr) != drc.Count - 1)
            {
                strResult.Append(",");
            }
        }
        strResult.Append("]");
        resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}