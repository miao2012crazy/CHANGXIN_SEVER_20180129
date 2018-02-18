<%@ WebHandler Language="C#" Class="search_user_address" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

public class search_user_address : IHttpHandler
{

    private Database db = new Database();
    private Query query = new Query();
    private DataRowCollection drc = null;
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string user_id = "";
    public void ProcessRequest(HttpContext context)
    {
        this.mContext = context;
        string key = context.Request.Form["key"];
        string body = context.Request.Form["body"];

        try
        {
            try
            {
                result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
                string json = AES.Decrypt(body, result, "");

                JObject obj = JObject.Parse(json.Split('#')[0]);
            
                user_id = obj["user_id"].ToString();
            }
            catch (Exception ex)
            {

                resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60078");
                return;
            }

            if (user_id == "" || user_id == null)
            {
                resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60077");
                context.Response.Write(strResult);
                return;
            }
            else
            {
                db.Connect();
                query.Clear();
                query.SetTable("TBL_USER_ADDRESS");
                query.AddColumn("*");
                query.AddCondition("USER_NO='" + user_id + "'");
                query.AddCondition("USER_ADDRESS_STATE=0");
                drc = db.GetDataRows(query.SelectQuery());
                if (drc.Count == 0)
                {
                    resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60067");
                    return;
                }
                getUserAddress();
                resopnse = JsonUtil.setJsonResult_new_2("S", strResult, "");
            }
        }
        catch (Exception ex)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60057");
        }
        finally
        {
            strResult.Clear();
            string res = AES.Encrypt(resopnse, result, "");
            context.Response.Write(res);
            try { db.Close(); } catch { }

        }
    }
    /// <summary>
    /// 获取指定时间段的商品
    /// </summary>
    public void getUserAddress()
    {
        foreach (DataRow dr in drc)
        {
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "address_no", dr["NO"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "is_default", dr["IS_DEFAULT"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "address_area", dr["ADDRESS_DETAIL1"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "address_detail", dr["ADDRESS_DETAIL2"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "recv_name", dr["RECV_NAME"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "recv_tel", dr["RECV_TEL"].ToString());
            strResult.Append("}");
            if (drc.IndexOf(dr) != drc.Count - 1)
            {
                strResult.Append(",");
            }
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}