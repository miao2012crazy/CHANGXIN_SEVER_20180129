﻿<%@ WebHandler Language="C#" Class="upload_product" %>

using System;
using System.Web;

public class upload_product : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}