<%@ WebHandler Language="C#" Class="search_product_index" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;

public class search_product_index : IHttpHandler
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

            //获取索引 搜索范围
            //终止日期 起始日期不要了  往前查三个月
            DateTime dt_end = TimeUtils.getEndDate();
            string end_time = TimeUtils.getEndDateWeek();
            string start_one = TimeUtils.getQuarterStart(dt_end);
            string end_one = TimeUtils.getQuarterEnd(dt_end);
            string start_two = TimeUtils.getQuarterStart(dt_end.AddMonths(-1));
            string end_two = TimeUtils.getQuarterEnd(dt_end.AddMonths(-1));
            string start_three = TimeUtils.getQuarterStart(dt_end.AddMonths(-2));
            string end_three = TimeUtils.getQuarterEnd(dt_end.AddMonths(-2));
            string[] str_start = { start_one, start_two, start_three };
            string[] str_end = { end_time, end_two, end_three };
            JsonUtil.setJson4(strResult, "date_list", "[");
            for (int i = 0; i < 3; i++)
            {
                strResult.Append("{");
                JsonUtil.setJson3(strResult, "month", TimeUtils.getMonth(i));
                strResult.Append(",");
                JsonUtil.setJson3(strResult, "img_url", "");
                strResult.Append(",");
                JsonUtil.setJson3(strResult, "start_time", str_start[i]);
                strResult.Append(",");
                JsonUtil.setJson3(strResult, "end_time", str_end[i]);
                strResult.Append("}");
                if (i != 2)
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