<%@ WebHandler Language="C#" Class="add_user_address" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

public class add_user_address : IHttpHandler
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
    private string item_type = "";

    public void ProcessRequest(HttpContext context)
    {
        this.mContext = context;
        string key = context.Request.Form["key"];
        string body = context.Request.Form["body"];
        try
        {
            db.Connect();
            result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
            string json = AES.Decrypt(body, result, "");

            obj = JObject.Parse(json.Split('#')[0]);

            user_id = obj["user_id"].ToString();
            //获取操作类型
            item_type = obj["type"].ToString();
            choseType(item_type);
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
    /// 选择操作类型
    /// </summary>
    /// <param name="type"></param>
    private void choseType(string type)
    {

        switch (type)
        {
            case "0":
                //添加新地址
                addNewAddress();
                break;
            case "1":
                //修改地址
                updateAddress();
                break;
            case "2":
                //删除地址
                deleteAddress();
                break;
            default:
                //JsonUtil.setJsonFailed(strResult, "60059");
                break;
        }
    }

    /// <summary>
    /// 添加地址
    /// </summary>
    public void addNewAddress()
    {
        strResult.Clear();
        string is_default = obj["is_default"].ToString();
        string address_area = obj["address_area"].ToString();
        string address_detail = obj["address_detail"].ToString();
        string recv_name = obj["recv_name"].ToString();
        string recv_tel = obj["recv_tel"].ToString();
        try
        {
            db.BeginTransaction();
            if (is_default == "1")
            {
                db.Execute("UPDATE TBL_USER_ADDRESS SET IS_DEFAULT=0 WHERE USER_NO='" + user_id + "'");
            }
            query.Clear();
            query.SetTable("TBL_USER_ADDRESS");
            query.AddColumn("USER_NO", user_id);
            query.AddColumn("IS_DEFAULT", is_default);
            query.AddNVColumn("ADDRESS_DETAIL1", address_area);
            query.AddNVColumn("ADDRESS_DETAIL2", address_detail);
            query.AddNVColumn("RECV_NAME", recv_name);
            query.AddNVColumn("RECV_TEL", recv_tel);
            db.Execute(query.InsertQuery());
            db.Commit();
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
        }
        catch (Exception ex)
        {

            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60080");
            db.Rollback();
        }
    }

    /// <summary>
    /// 修改地址
    /// </summary>
    public void updateAddress()
    {
        strResult.Clear();
        string is_default = obj["is_default"].ToString();
        string address_area = obj["address_area"].ToString();
        string address_detail = obj["address_detail"].ToString();
        string recv_name = obj["recv_name"].ToString();
        string recv_tel = obj["recv_tel"].ToString();
        string address_no = obj["address_id"].ToString();

        try
        {
            db.BeginTransaction();
            if (is_default == "1")
            {
                db.Execute("UPDATE TBL_USER_ADDRESS SET IS_DEFAULT=0 WHERE USER_NO='" + user_id + "'");
            }
            query.Clear();
            query.SetTable("TBL_USER_ADDRESS");
            query.AddColumn("USER_NO", user_id);
            query.AddColumn("IS_DEFAULT", is_default);
            query.AddNVColumn("ADDRESS_DETAIL1", address_area);
            query.AddNVColumn("ADDRESS_DETAIL2", address_detail);
            query.AddNVColumn("RECV_NAME", recv_name);
            query.AddNVColumn("RECV_TEL", recv_tel);
            query.AddCondition("NO=" + address_no);
            db.Execute(query.UpdateQuery());
            db.Commit();
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
        }
        catch (Exception ex)
        {
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60080");
            db.Rollback();
        }
    }

    /// <summary>
    /// 删除地址
    /// </summary>
    public void deleteAddress()
    {
        string address_no = obj["address_id"].ToString();
        strResult.Clear();
        try
        {
            DataRow dr = db.GetDataRow("SELECT * FROM TBL_USER_ADDRESS WHERE NO='" + address_no + "'");

            if (dr["IS_DEFAULT"].ToString() == "1")
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60082");
                return;
            }
            db.Execute("DELETE FROM TBL_USER_ADDRESS WHERE USER_NO='" + user_id + "' AND NO =" + address_no);
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
        }
        catch(Exception ex)
        {
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60081");
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