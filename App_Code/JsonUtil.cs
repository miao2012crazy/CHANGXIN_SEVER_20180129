using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using Newtonsoft.Json;

/// <summary>
/// JsonUtil 的摘要说明
/// </summary>
public static class JsonUtil
{
    private static StringBuilder strResult = new StringBuilder();
    
    public static string setJsonResult_new(string code,StringBuilder strResult_0,string err_msg) {
        strResult.Clear();
        switch (code) {
            case "S":
                setJsonSuccess(strResult);
                setJson2(strResult, "data", "{");
                strResult.Append(strResult_0);
                strResult.Append("}");
                strResult.Append("}");
                return strResult.ToString();
            case "F":
                setJsonFailed(strResult, err_msg);
                return strResult.ToString();
            case "T":
                setJsonNoLogin(strResult);
                return strResult.ToString();
        }
      
        return "";
    }


    public static string setJsonResult_new_2(string code, StringBuilder strResult_0, string err_msg)
    {
        strResult.Clear();
        switch (code)
        {
            case "S":
                setJsonSuccess(strResult);
                setJson2(strResult, "data", "[");
                strResult.Append(strResult_0);
                strResult.Append("]");
                strResult.Append("}");
                return strResult.ToString();
            case "F":
                setJsonFailed(strResult, err_msg);
                return strResult.ToString();
            case "T":
                setJsonNoLogin(strResult);
                return strResult.ToString();
        }

        return "";
    }








    private static void setJsonSuccess(StringBuilder jsonResult)
    {
        jsonResult.Append("{\"" + "code" + "\":\"" + "S" + "\"");
    }
    public static void setJson1(StringBuilder jsonResult, string key, string val)
    {
        jsonResult.Append("{\"" + key + "\":\"" + val + "\"");
    }
    /// <summary>
    ///  ,key:val
    /// </summary>
    /// <param name="jsonResult"></param>
    /// <param name="key"></param>
    /// <param name="val"></param>
    public static void setJson2(StringBuilder jsonResult, string key, string val)
    {
        jsonResult.Append(",\"" + key + "\":" + val);
    }
    /// <summary>
    ///  key:val
    /// </summary>
    /// <param name="jsonResult"></param>
    /// <param name="key"></param>
    /// <param name="val"></param>
    public static void setJson3(StringBuilder jsonResult, string key, string val)
    {
        jsonResult.Append("\"" + key + "\"" + ":\"" + val + "\"");
    }

    public static void setJson4(StringBuilder jsonResult, string key, string val)
    {
        jsonResult.Append("\"" + key + "\":" + val);
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="jsonResult"></param>
    /// <param name="key"></param>
    /// <param name="val"></param>
    public static void setJson5(StringBuilder jsonResult, string val)
    {
        jsonResult.Append("\"" + val + "\"" );
    }


    /// <summary>
    /// 各类失败
    /// </summary>
    /// <param name="jsonResult"></param>
    /// <param name="key"></param>
    /// <param name="val"></param>
    private static void setJsonFailed(StringBuilder jsonResult, string err_msg)
    {
        setJson1(jsonResult, "code", "F");
        setJson2(jsonResult, "err_msg", "\"" + err_msg + "\"");
        jsonResult.Append("}");
    }
    /// <summary>
    /// 未登录
    /// </summary>
    /// <param name="jsonResult"></param>
    /// <param name="err_msg"></param>
    private static void setJsonNoLogin(StringBuilder jsonResult)
    {
        setJson1(jsonResult, "code", "T");
        jsonResult.Append(",");
        setJson3(jsonResult, "msg", "未登录");
        jsonResult.Append("}");
    }
  
}