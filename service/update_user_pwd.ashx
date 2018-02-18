\
<%@ WebHandler Language="C#" Class="update_user_pwd" %>
using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;


/// <summary>
/// 更新密码
/// </summary>
public class update_user_pwd : IHttpHandler
{
    private Database db = new Database();
    private Query query = new Query();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private StringBuilder strResult = new StringBuilder();
    private JObject obj = null;
    private string user_id;
    private string user_old_psd;
    private string user_new_psd;

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            try
            {
                string key = context.Request.Form["key"];
                string body = context.Request.Form["body"];
                result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
                string json = AES.Decrypt(body, result, "");
                obj = JObject.Parse(json.Split('#')[0]);
                user_id = obj["user_id"].ToString();
                user_old_psd = obj["old_pwd"].ToString();
                user_new_psd = obj["new_pwd"].ToString();

            }
            catch
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }

            //查询数据库 user_对应的id
            db.Connect();
            query.Clear();
            query.SetTable("TBL_USER");
            query.AddColumn("*");
            query.AddCondition("ID='" + user_id + "'");
            DataRow dr = db.GetDataRow(query.SelectQuery());
            if (dr == null)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60090");
                return;
            }
            //密码不匹配
            if (!dr["PASSWORD"].ToString().Equals(user_old_psd))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60091");
                return;
            }


            db.BeginTransaction();
            query.Clear();
            query.SetTable("TBL_USER");
            query.AddColumn("PASSWORD", user_new_psd);
            query.AddCondition("ID='" + user_id + "'");
            db.Execute(query.UpdateQuery());
            db.Commit();
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
        }
        catch (Exception ex)
        {
            db.Rollback();
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}