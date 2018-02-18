<%@ WebHandler Language="C#" Class="upload_client_id" %>


using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

/// <summary>
/// 用户上传client_id 
/// </summary>
public class upload_client_id : IHttpHandler
{
    private DataRow dr;
    private DataRow drUser = null;
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string user_id = "";
    private string client_id = "";
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
                client_id = obj["client_id"].ToString();
                user_id = obj["user_id"].ToString();
            }
            catch (Exception ex)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }
            db.Connect();
            try
            {
                getUserInfo();
            }
            catch { }

            db.BeginTransaction();
            query.Clear();
            query.SetTable("TBL_USER_PUSH_CLIENTID");
            query.AddColumn("*");
            query.AddCondition("PUSH_CLIENT_ID='" + client_id + "'");
            DataRow dr = db.GetDataRow(query.SelectQuery());
            if (dr != null)
            {
                if (dr["USER_ID"].ToString().Equals(""))
                {
                    updatePushClientID();
                }
                else
                {
                    resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
                }
            }
            else {
                //插入一条新的数据
                insertPushClientID();
            }

        }
        catch (Exception ex)
        {

            try { db.Rollback(); } catch { }
            resopnse = JsonUtil.setJsonResult_new("F", strResult, ex.Message);
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
    /// 插入一条新数据
    /// </summary>
    private void insertPushClientID()
    {
        query.Clear();
        query.SetTable("TBL_USER_PUSH_CLIENTID");
        if (drUser != null)
        {
            query.AddColumn("USER_NO", drUser["NO"].ToString());
            query.AddColumn("USER_REGEDIT_STATE", 1);
            query.AddColumn("USER_ID", drUser["ID"].ToString());
            query.AddColumn("USER_NICKNAME", drUser["NICKNAME"].ToString());
        }

        query.AddColumn("PUSH_CLIENT_ID", client_id);
        db.Execute(query.InsertQuery());
        db.Commit();
        resopnse = JsonUtil.setJsonResult_new_2("S", strResult, "");
    }


    /// <summary>
    /// 更新用户client_id
    /// </summary>
    private void updatePushClientID()
    {
        query.Clear();
        query.SetTable("TBL_USER_PUSH_CLIENTID");
        query.AddColumn("USER_NO", drUser["NO"].ToString());
        query.AddColumn("USER_REGEDIT_STATE", 1);
        query.AddColumn("USER_ID", drUser["ID"].ToString());
        query.AddColumn("USER_NICKNAME", drUser["NICKNAME"].ToString());
        query.AddCondition("PUSH_CLIENT_ID='" + client_id + "'");
        db.Execute(query.UpdateQuery());
        db.Commit();
        resopnse = JsonUtil.setJsonResult_new_2("S", strResult, "");
    }


    /// <summary>
    /// 获取用户信息
    /// </summary>
    private void getUserInfo()
    {
        query.Clear();
        query.SetTable("TBL_USER");
        query.AddColumn("*");
        query.AddCondition("ID='" + user_id + "'");
        drUser = db.GetDataRow(query.SelectQuery());
        //if (drUser["USER_REAL_STATE"].ToString().Equals("1"))
        //{
        //    strResult.Clear();
        //    resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60070");
        //    drUser = null;
        //}
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}