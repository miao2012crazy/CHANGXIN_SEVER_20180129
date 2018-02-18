<%@ WebHandler Language="C#" Class="TestRSAAES" %>

using System;
using System.Web;
using AppCommon;
using System.Text;
using System.Data;

public class TestRSAAES : IHttpHandler
{
    private Database db = new Database();
    private Query query = new Query();
    public void ProcessRequest(HttpContext context)
    {
        //db.Connect();
        //query.SetTable("TBL_USER");
        //query.AddColumn("*");
        //db.Execute(query.SelectQuery());
        //context.Response.Write(query.SelectQuery());
         //toList接口每个用户状态返回是否开启，可选

      string msg=  PushUtil.PushMessageToSingle();
        context.Response.Write(msg);
        //string key = context.Request.Form["key"];
        //string body = context.Request.Form["body"];
        //string result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
        //context.Response.Write("解密结果key::" + result);
        ////string ddd = AES.Encrypt_AES("123456", result);
        ////string sss = AES.Decrypt_AES("wDm0zQqN83xuTN2877nXkw==", "2AD0ACCAA4C5683755DAEC027ED65A6B");
        //string jieguo = AES.Decrypt(body, result, "");
        //context.Response.Write("解密结果body::" + jieguo);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}