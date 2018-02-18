<%@ WebHandler Language="C#" Class="search_past_product_index" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
/// <summary>
/// 往期商品索引
/// </summary>
public class search_past_product_index : IHttpHandler
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

            DateTime dt_end = TimeUtils.getEndDate();
            string start_one = TimeUtils.getQuarterStart(dt_end.AddMonths(-3));
            string end_one = TimeUtils.getQuarterEnd(dt_end.AddMonths(-3));
            string start_two = TimeUtils.getQuarterStart(dt_end.AddMonths(-4));
            string end_two = TimeUtils.getQuarterEnd(dt_end.AddMonths(-4));
            string start_three = TimeUtils.getQuarterStart(dt_end.AddMonths(-5));
            string end_three = TimeUtils.getQuarterEnd(dt_end.AddMonths(-5));
            string[] str_start = { start_one, start_two, start_three };
            string[] str_end = { end_one, end_two, end_three };
            JsonUtil.setJson4(strResult, "date_list", "[");
            for (int i = 3; i < 6; i++)
            {
                strResult.Append("{");
                JsonUtil.setJson3(strResult, "month", TimeUtils.getMonth(i));
                strResult.Append(",");
                JsonUtil.setJson3(strResult, "img_url", "");
                strResult.Append(",");
                JsonUtil.setJson3(strResult, "start_time", str_start[i-3]);
                strResult.Append(",");
                JsonUtil.setJson3(strResult, "end_time", str_end[i-3]);
                strResult.Append("}");
                if (i != 5)
                {
                    strResult.Append(",");
                }
            }
            strResult.Append("]");
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