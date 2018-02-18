<%@ WebHandler Language="C#" Class="search_user_order" %>
using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

public class search_user_order : IHttpHandler
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
        mContext = context;
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
                item_type = obj["item_type"].ToString();
            }
            catch (Exception ex)
            {
                resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60078");
                return;
            }
            db.Connect();
            getDataForOrderState();
        }
        catch (Exception ex)
        {
                context.Response.Write(ex.Message);

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
    /// 获取待支付列表
    /// </summary>
    private void getDataForOrderState()
    {
        query.Clear();
        query.SetTable("TBL_USER_ORDER");
        query.AddColumn("*");
        query.AddCondition("USER_NO='" + user_id + "'");

        if (item_type.Equals("6"))
        {
            query.AddCondition("ORDER_STATE=" + item_type
                + " OR " + "ORDER_STATE=" + "7"
                + " OR " + "ORDER_STATE=" + "8"
                + " OR " + "ORDER_STATE=" + "9");
        }

        if (item_type.Equals("1"))
        {
            query.AddCondition("ORDER_STATE=" + item_type
         + " OR " + "ORDER_STATE=" + "2"
       );
        }


        else
        {
            query.AddCondition("ORDER_STATE=" + item_type);
        }
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        foreach (DataRow dr in drc)
        {

            //待付款订单
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "bad_reason", dr["FEEDBACK_BAD_REASON"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "order_state", dr["ORDER_STATE"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "order_id", dr["ORDER_NO"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "img_url", ImgPath.base_product_path + dr["PRODUCT_CODE"] + "/" + dr["PRODUCT_IMAGE1"].ToString().Trim());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_id", dr["PRODUCT_CODE"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_name", dr["PRODUCT_NAME"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "private_deposit", dr["PRODUCT_PRICE"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "cash_state", dr["PRODUCT_EVAL_DEPOSIT_REFUND_RATE"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "pay_date", dr["PAY_DATE"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "commit_date", dr["COMMIT_FEEDBACK_DATE"].ToString());
            strResult.Append("}");
            if (drc.IndexOf(dr) != drc.Count - 1)
            {
                strResult.Append(",");
            }
        }

        resopnse = JsonUtil.setJsonResult_new_2("S", strResult, "");
    }









    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}