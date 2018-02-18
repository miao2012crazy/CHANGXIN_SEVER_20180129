<%@ WebHandler Language="C#" Class="cancel_user_order" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

public class cancel_user_order : IHttpHandler
{
    private Database db = new Database();
    private Query query = new Query();
    private DataRowCollection drc = null;
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private JObject obj = null;
    private string user_id = "";
    private string order_id = "";
    public void ProcessRequest(HttpContext context)
    {
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
                order_id = obj["order_id"].ToString();

            }
            catch (Exception ex)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }
            if (user_id.Equals("") || order_id.Equals(""))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60059");
                return;
            }
            db.Connect();
            cancelOrder(order_id, user_id);
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
    /// 取消订单
    /// </summary>
    /// <param name="order_id"></param>
    /// <param name="user_id"></param>
    private void cancelOrder(string order_id, string user_id)
    {
        query.Clear();
        query.SetTable("TBL_USER_ORDER");
        query.AddColumn("*");
        query.AddCondition("USER_NO='" + user_id + "'");
        query.AddCondition("ORDER_NO='" + order_id + "'");
        DataRow dr = db.GetDataRow(query.SelectQuery());
        if (dr == null)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60066");
            return;
        }
        //检查订单状态
        if (dr["ORDER_STATE"].ToString().Equals("0"))
        {
            query.Clear();
            query.SetTable("TBL_USER_ORDER");
            query.AddColumn("ORDER_STATE", "5");
            query.AddCondition("USER_NO='" + user_id + "'");
            query.AddCondition("ORDER_NO='" + order_id + "'");
            db.Execute(query.UpdateQuery());
            //db.Commit();
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "订单已取消");
        }
        else
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60085");
            return;
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