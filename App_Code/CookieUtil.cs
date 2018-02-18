using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Cookie 的摘要说明
/// </summary>
public class CookieUtil
{
    private static HttpResponse respone = HttpContext.Current.Response;
    private static HttpRequest requst = HttpContext.Current.Request;
    /// <summary>
    /// 添加cookie并写入value
    /// </summary>
    /// <param name="cookName">新建的cookie的名称</param>
    /// <param name="cookValue">新建的cookie的值</param>
    /// <param name="expriTime">cookie的有效期以天为单位，-2表示不设置有效期</param>
    public static void AddCookies(string cookName, string cookValue, double expriTime)
    {
        if (requst.Cookies[cookName] != null)
        {
            DelCookies(cookName);
        }
        HttpCookie cook = new HttpCookie(cookName);
        if (expriTime != -2)
            cook.Expires = DateTime.Now.AddDays(expriTime);
        cook.Value = cookValue;
        respone.AppendCookie(cook);
    }
    /// <summary>
    /// 添加有键值的cookie
    /// </summary>
    /// <param name="cookName">cookie的名称</param>
    /// <param name="key">cookie内键值的名称</param>
    /// <param name="keyValue">cookie的键值value</param>
    /// <param name="expritime">cookie的有效期以天为单位，-2表示不设置有效期</param>
    public static void AddCookies(string cookName, string key, string keyValue, double expritime)
    {
        HttpCookie cook = new HttpCookie(cookName);
        if (!string.IsNullOrEmpty(key))
            cook.Values.Add(key, keyValue);
        if (expritime != -2)
            cook.Expires = DateTime.Now.AddDays(expritime);
        respone.AppendCookie(cook);
    }
    /// <summary>
    /// 设置cookie的有效期过期(删除cookie)
    /// </summary>
    /// <param name="cookName">要设置的cookie的名称</param>
    public static void DelCookies(string cookName)
    {
        DelCookiesValue(cookName, null);
    }
    /// <summary>
    /// 删除cookie或者删除cookie的键值
    /// </summary>
    /// <param name="cookName">cookie的名称</param>
    /// <param name="key">键值的名称（如果为NULL则运行删除cookie的代码，否则运行删除cookie中的键值的代码）</param>
    public static void DelCookiesValue(string cookName, string key)
    {
        HttpCookie cook = requst.Cookies[cookName];
        if (cook != null)
        {
            if (!string.IsNullOrEmpty(key) && cook.HasKeys)
            {
                if (cook.Values.Count <= 1)
                    cook.Expires = DateTime.Now.AddDays(-1);
                else
                    cook.Values.Remove(key);
                respone.AppendCookie(cook);
            }
            else
            {
                cook.Expires = DateTime.Now.AddDays(-1);
                respone.AppendCookie(cook);
            }
        }
    }
    /// <summary>
    /// 获取cookie的值
    /// </summary>
    /// <param name="cookName">cookie的名称</param>
    /// <returns>返回cookie的值，如果不存在cookie则返回NULL</returns>
    public static string GetCookieValue(string cookName)
    {
        return GetCookieOrKeyValue(cookName, null);
    }
    /// <summary>
    /// 获取cookie的值或cookie的键值
    /// </summary>
    /// <param name="cookName">cookie的名称</param>
    /// <param name="keyName">cookie内键值的名称（NULL代表获取cookie的值）</param>
    /// <returns>返回cookie的值或者键值，如果不存在cookie则返回NULL</returns>
    public static string GetCookieOrKeyValue(string cookName, string keyName)
    {
        HttpCookie cook = requst.Cookies[cookName];
        if (cook != null)
        {
            if (!string.IsNullOrEmpty(keyName) && cook.HasKeys)
                return cook.Values[keyName].ToString();
            else
                return cook.Value.ToString();
        }
        return null;
    }
}