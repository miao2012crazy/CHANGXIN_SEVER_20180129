<%@ WebHandler Language="C#" Class="regedit_user_info" %>


using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;
/// <summary>
/// 用户注册
/// </summary>
public class regedit_user_info : IHttpHandler
{
    private DataRow dr;
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string user_tel = "";
    private string user_psd = "";
    private string verify_code = "";
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
                user_tel = obj["user_tel"].ToString();
                user_psd = obj["user_psd"].ToString();
                verify_code = obj["verify_code"].ToString();



            }
            catch (Exception ex)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }

            if (user_tel.Equals(""))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60092");
                return;
            }
            if (user_psd.Equals(""))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60092");
                return;
            }
            if (user_psd.Equals(""))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60092");
                return;
            }
            db.Connect();
            query.Clear();
            //验证手机号是否已经注册
            query.SetTable("TBL_USER");
            query.AddColumn("*");
            query.AddCondition("MOBILE='" + user_tel + "'");
            DataRow dr = db.GetDataRow(query.SelectQuery());
            if (dr != null)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60093");
                return;
            }
            //插入新用户
            db.BeginTransaction();
            query.Clear();
            query.SetTable("TBL_USER");
            query.AddColumn("MOBILE",user_tel);
            query.AddColumn("PASSWORD",user_psd);




        }
        catch (Exception ex)
        {
            try{db.Rollback();}catch { }
        }
        finally {




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