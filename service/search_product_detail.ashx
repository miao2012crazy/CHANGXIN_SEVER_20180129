<%@ WebHandler Language="C#" Class="search_product_detail" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;


public class search_product_detail : IHttpHandler
{
    private DataRow dr;
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string product_id = "";
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
                product_id = obj["product_id"].ToString();
                context.Response.Write(obj);
                //context.Response.Write(product_id);
            }
            catch (Exception ex)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }

            db.Connect();
            //string product_id = context.Request.Form["product_id"].ToString();
            if (product_id == "" || product_id == null)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60077");
                //context.Response.Write(strResult);
                return;
            }
            else
            {
                query.Clear();
                query.SetTable("TBL_PRODUCT");
                query.AddColumn("*");
                query.AddCondition("PRODUCT_CODE='" + product_id + "'");
                dr = db.GetDataRow(query.SelectQuery());
                if (dr == null)
                {
                    resopnse = JsonUtil.setJsonResult_new("F", strResult, "60077");
                    return;
                }
                getDataForProduct_ID();
                getSpecialUser(product_id);
                getNextProduct();
                resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
            }
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
    /// 根据产品id 获取产品信息
    /// </summary>
    public void getDataForProduct_ID()
    {
        JsonUtil.setJson3(strResult, "stamp", TimeUtils.GetWeekLastDaySat());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "product_id", dr["PRODUCT_CODE"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "product_name", dr["PRODUCT_NAME"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "product_desc", dr["PRODUCT_DESC"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "product_total_num", dr["PRODUCT_STOCK"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "product_buy_num", dr["PRODUCT_MINSELL_STOCK"].ToString());
        strResult.Append(",");
        //抢购价
        JsonUtil.setJson3(strResult, "product_eval_price", dr["PRODUCT_PRICE"].ToString());
        strResult.Append(",");
        //原价
        JsonUtil.setJson3(strResult, "product_orign_price", dr["PRODUCT_ORIGIN_PRICE"].ToString());
        strResult.Append(",");
        JsonUtil.setJson3(strResult, "img_url", ImgPath.base_product_path + dr["PRODUCT_CODE"] + "/" + dr["PRODUCT_IMAGE1"].ToString().Trim());
    }



    /// <summary>
    /// 获取下周产品信息
    /// </summary>
    public void getNextProduct()
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT");
        query.AddColumn("*");
        query.AddCondition("PRODUCT_EVAL_STATE='1'");
        query.AddCondition("PRODUCT_EVAL_WEEKS=" + (int.Parse(TimeUtils.WeekOfYear(DateTime.Now)) + 1));
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        strResult.Append(",");
        JsonUtil.setJson4(strResult, "product_next_week", "[");
        foreach (DataRow dr in drc)
        {
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "img_url", ImgPath.base_product_path + dr["PRODUCT_CODE"] + "/" + dr["PRODUCT_IMAGE2"].ToString().Trim());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_total_num", dr["PRODUCT_STOCK"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_name", dr["PRODUCT_NAME"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "product_id", dr["PRODUCT_CODE"].ToString());
            strResult.Append("}");
            if (drc.IndexOf(dr) != drc.Count - 1)
            {
                strResult.Append(",");
            }
        }
        strResult.Append("]");
    }

    /// <summary>
    /// 获取当前产品的特邀用户
    /// </summary>
    /// <param name="product_id"></param>
    public void getSpecialUser(string product_id)
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT_SPECIAL_USER");
        query.AddColumn("*");
        query.AddCondition("PRODUCT_NO=" + product_id);
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        strResult.Append(",");
        JsonUtil.setJson4(strResult, "special_user", "[");
        foreach (DataRow dr in drc)
        {
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "user_head_img", ImgPath.base_special_user_path + dr["USER_HEAD_IMG"].ToString().Trim());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "user_tag", dr["USER_TAG"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "user_nick_name", dr["USER_NICK_NAME"].ToString());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "user_id", dr["USER_NO"].ToString());
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