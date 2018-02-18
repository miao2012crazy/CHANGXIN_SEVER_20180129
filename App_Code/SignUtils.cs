using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
//这个引用很重要，必须要有 数据加密
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;

/// <summary>
/// SignUtils 的摘要说明
/// </summary>
public static class SignUtils
{
    //每次请求需校验时间差 10秒内的请求有效 超出则当前请求失效
    public static int TIME_DIFFERENCE = 10;
    private static string PRIVATRE_KEY = "kalsjdhfiau1231255647wealskjdas";
    //请求参数数组
    public static Boolean check_sign(string[] str,string client_sign,string updateTime)
    {
        string signStr = "";
        //校验时间 超过10秒 不再处理
        long current_time = TimeUtils.getTimeStampForLong(DateTime.Now);
        long client_time = long.Parse(updateTime);
        if (current_time - client_time > TIME_DIFFERENCE)
        {
            return false;
        }
        for (int i = 0; i < str.Length; i++)
        {
            signStr += str[i];
            if (i != str.Length - 1)
            {
                signStr += "&";
            }
        }

        string encodestr=HttpUtility.UrlEncode(signStr, Encoding.UTF8);

        string MD5sign= FormsAuthentication.HashPasswordForStoringInConfigFile(encodestr+PRIVATRE_KEY, "MD5").ToLower();
        if (MD5sign.Equals(client_sign))
        {
            return true;
        }
        else {
            return false;
        }
    }

    //RSA 加密








}