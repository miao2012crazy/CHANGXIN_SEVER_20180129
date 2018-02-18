<%@ WebHandler Language="C#" Class="search_login" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

public class search_login : IHttpHandler
{
    private DataRow dr;
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string user_id = "";
    private string user_psd = "";
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            this.mContext = context;
            string key = context.Request.Form["key"];
            string body = context.Request.Form["body"].Trim();
            try
            {
                result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
                string json = AES.Decrypt(body, result, "");
                string[] str = json.Split('#');
                JObject obj = JObject.Parse(str[0]);
                user_id = obj["user_id"].ToString();
                user_psd = obj["user_psd"].ToString();
            }
            catch (Exception ex)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }

            db.Connect();
            query.Clear();
            query.SetTable("TBL_USER");
            query.AddColumn("*");
            query.AddCondition("ID='" + user_id + "'");
            dr = db.GetDataRow(query.SelectQuery());
            if (dr == null)
            {
                strResult.Clear();
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60050");
                return;
            }
            if (dr["USER_STATE"].Equals("1"))
            {
                strResult.Clear();
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60079");
                return;
            }

            if (!dr["PASSWORD"].ToString().Equals(user_psd))
            {
                strResult.Clear();
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60051");
                return;
            }
            getDataForUser();
        }
        catch (Exception ex)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60057");
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
    /// 根据用户id  获取用户信息
    /// </summary>
    public void getDataForUser()
    {
        JsonUtil.setJson3(strResult, "user_id", dr["ID"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "user_nick_name", dr["NICKNAME"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "wechat_union_id", dr["WECHAT_UNION_ID"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "mobile", dr["MOBILE"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "gender", dr["GENDER"].ToString());
        strResult.Append(",");
        //出生日期
        JsonUtil.setJson3(strResult, "date_birth", dr["DATE_BIRTH"].ToString());
        strResult.Append(",");
        //真是姓名
        JsonUtil.setJson3(strResult, "real_name", dr["REAL_NAME"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "user_head_img", ImgPath.base_special_user_path + dr["USER_HEAD_IMG"].ToString().Trim());
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