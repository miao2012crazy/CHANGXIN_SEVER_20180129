<%@ WebHandler Language="C#" Class="search_product_quarter" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

public class search_product_quarter : IHttpHandler
{
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string start = "";
    private string end = "";
    public void ProcessRequest(HttpContext context)
    {

        try
        {
            string key = context.Request.Form["key"];
            string body = context.Request.Form["body"].Trim();
            try
            {
                result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
                string json = AES.Decrypt(body, result, "");
                string[] str = json.Split('#');
                JObject obj = JObject.Parse(str[0]);
                start = obj["start_time"].ToString();
                end = obj["end_time"].ToString();
            }
            catch (Exception ex)
            {
                   
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60078");
                return;
            }


            //终止日期 起始日期不要了  往前查三个月
            //DateTime dt_end = TimeUtils.getEndDate();
            //string end_time = TimeUtils.getEndDateWeek();
            //string start_one = TimeUtils.getQuarterStart(dt_end);
            //string end_one = TimeUtils.getQuarterEnd(dt_end);

            //string start_two = TimeUtils.getQuarterStart(dt_end.AddMonths(-1));
            //string end_two = TimeUtils.getQuarterEnd(dt_end.AddMonths(-1));

            //string start_three = TimeUtils.getQuarterStart(dt_end.AddMonths(-2));
            //string end_three = TimeUtils.getQuarterEnd(dt_end.AddMonths(-2));

            //context.Response.Write("本月:" + start_one + "==" + end_time + "\n");
            //context.Response.Write("上月:" + start_two + "==" + end_two + "\n");
            //context.Response.Write("前月:" + start_three + "==" + end_three + "\n");
            db.Connect();
            getProduct_List(start, end);
            //getProduct_List(start_two, end_two, "product_last_month");
            resopnse = JsonUtil.setJsonResult_new_2("S", strResult, "");

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
    /// 获取指定时间段的商品
    /// </summary>
    public void getProduct_List(string start_time, string end_time)
    {
        int start = int.Parse(start_time);
        int end = int.Parse(end_time);
        for (int i = start; i <= end; i++)
        {
            query.Clear();
            query.SetTable("TBL_PRODUCT");
            query.AddColumn("*");
            query.AddCondition("PRODUCT_EVAL_STATE='1'");
            query.AddCondition("PRODUCT_EVAL_WEEKS=" + i);
            //JsonUtil.setJson4(strResult, "week_par"+i, "{");
            strResult.Append("{");
            JsonUtil.setJson3(strResult, "product_periods", (i - 201800) + "");
            strResult.Append(",");
            JsonUtil.setJson3(strResult, "periods_start", "2018" + i);
            strResult.Append(",");

            JsonUtil.setJson4(strResult, "week_time", "[");
            DataRowCollection drc = db.GetDataRows(query.SelectQuery());
            foreach (DataRow dr in drc)
            {
                //上周
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
            strResult.Append("}");
            if (i != end)
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