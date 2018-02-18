<%@ WebHandler Language="C#" Class="search_product_list" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;

public class search_product_list : IHttpHandler
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
            mContext = context;
            db.Connect();
            query.Clear();
            JsonUtil.setJson3(strResult, "stamp", TimeUtils.GetWeekLastDaySat());
            strResult.Append(",");
            getLoopList();
            //strResult.Append(",");
            getProduct_List();
            getNextProduct();
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
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
    /// 获取轮播图数据  活动  和 活动信息
    /// </summary>
    public void getLoopList()
    {
        query.Clear();
        query.SetTable("TBL_ACTIVITY");
        query.AddColumn("*");
        query.AddCondition("ACTIVITY_AVAILABLE_WEEK=" + (int.Parse(TimeUtils.WeekOfYear(DateTime.Now))));
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        JsonUtil.setJson4(strResult, "loop_list", "[");
        foreach (DataRow dr in drc)
        {
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "activity_img", ImgPath.base_activity_path + dr["ACTIVITY_NO"] + "/" + dr["ACTIVITY_IMG_MAIN"].ToString().Trim());
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "activity_link", dr["ACTIVITY_IMG_MAIN"].ToString());
            strResult.Append("}");
            if (drc.IndexOf(dr) != drc.Count - 1)
            {
                strResult.Append(",");
            }
        }
        strResult.Append("]");
    }

    /// <summary>
    /// 获取本周商品
    /// </summary>
    public void getProduct_List()
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT");
        query.AddColumn("*");
        query.AddCondition("PRODUCT_EVAL_STATE='1'");
        query.AddCondition("PRODUCT_EVAL_WEEKS=" + TimeUtils.WeekOfYear(DateTime.Now));
        DataRowCollection drc = db.GetDataRows(query.SelectQuery());
        //foreach (DataRow dr in drc)
        //{
        //    string availabletime = dr["AVAILABLE_TIME"].ToString().Trim();
        //    long time = long.Parse(availabletime);
        //    long current_time = long.Parse(TimeUtils.getTimeStamp(DateTime.Now));
        //    long a = time - current_time;
        //    if (a < 0)
        //    {
        //        //更新产品状态
        //        setProductState(dr["ID"].ToString());
        //        getProduct_List();
        //    }
        //}
             strResult.Append(",");
        JsonUtil.setJson4(strResult, "product_list_week", "[");
        foreach (DataRow dr in drc)
        {
            //本周
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
    }
    /// <summary>
    /// 更新产品状态
    /// </summary>
    /// <param name="id"></param>
    public void setProductState(string id)
    {
        query.Clear();
        query.SetTable("CX_PRODUCT");
        query.AddColumn("PRODUCT_STATE", "2");
        query.AddCondition("ID=" + id);
        db.Execute(query.UpdateQuery());
    }
    
    
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
            JsonUtil.setJson3(strResult, "product_id", dr["PRODUCT_CODE"].ToString());
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