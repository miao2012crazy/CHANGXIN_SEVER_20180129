<%@ WebHandler Language="C#" Class="commit_report" %>

using System;
using System.Web;
using System.IO;
using AppCommon;
using System.Data;
using System.Text;

public class commit_report : IHttpHandler
{
    private Random r = new Random(BitConverter.ToInt32(Guid.NewGuid().ToByteArray(), 0));
    private string user_id;
    private string order_id;
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string image_path = "";
    private string video_path = "";
    private DataRow drUser = null;
    private DataRow drOrder = null;
    private DataRow drCategroyName = null;
    private string report_id = "";
    private string process = "";
    private string score = "";

    public void ProcessRequest(HttpContext context)
    {
        this.mContext = context;
        user_id = context.Request.Form["user_id"];
        order_id = context.Request.Form["order_id"];
        //获取试用过程 
        process = mContext.Request.Form["process"];
        score = mContext.Request.Form["score"];
        if (user_id == "" || order_id == "" || process == "" || score == "" || user_id == null || order_id == null || process == null || score == null)
        {
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60059");
            context.Response.Write(resopnse);
            return;
        }
        image_path = context.Server.MapPath("../Storage/report/" + user_id + "/image/");
        video_path = context.Server.MapPath("../Storage/report/" + user_id + "/video/");
        if (Directory.Exists(image_path) == false)
        {
            Directory.CreateDirectory(image_path);
        }
        if (Directory.Exists(video_path) == false)
        {
            Directory.CreateDirectory(video_path);
        }
        db.Connect();
        db.BeginTransaction();
        try
        {
            query.Clear();
            query.SetTable("TBL_USER_ORDER");
            query.AddColumn("*");
            query.AddCondition("ORDER_NO='" + order_id + "'");
            drOrder = db.GetDataRow(query.SelectQuery());
            getUserInfo();
            getImageAndVideo();
            updateOrderState();
        }
        catch (Exception ex)
        {
            db.Rollback();
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60057");
        }
        finally
        {
            context.Response.Write(resopnse);
            db.Close();
        }
    }

    private void getUserInfo()
    {
        query.Clear();
        query.SetTable("TBL_USER");
        query.AddColumn("*");
        query.AddCondition("ID='" + user_id + "'");
        drUser = db.GetDataRow(query.SelectQuery());


    }

    /// <summary>
    /// 获取视频和照片 插入表
    /// </summary>
    private void getImageAndVideo()
    {
        getProductCategoryName();
        query.Clear();
        query.SetTable("TBL_PRODUCT_FEEDBACK");
        query.AddColumn("USER_NO", drUser["NO"].ToString());
        query.AddColumn("USER_ID", user_id);
        query.AddColumn("USER_NICKNAME", drUser["NICKNAME"].ToString());
        query.AddColumn("PROCESS", process);
        query.AddColumn("PROGRESS_STATE", "1");
        query.AddColumn("FEEDBACK_SCORE", score);
        query.AddColumn("PRODUCT_CATEGORY_NAME", drCategroyName["CATEGORY_NAME"].ToString());
        query.AddColumn("PRODUCT_NO", drOrder["PRODUCT_CODE"].ToString());
        query.AddColumn("PRODUCT_NAME", drOrder["PRODUCT_NAME"].ToString());
        query.AddColumn("PRODUCT_ORIGINAL_NAME", drOrder["PRODUCT_ORIGINAL_NAME"].ToString());
        query.AddColumn("PRODUCT_IMAGE1", drOrder["PRODUCT_IMAGE1"].ToString());
        query.AddCondition("ORDER_NO = '" + order_id + "'");
        db.Execute(query.InsertQuery());
        report_id = db.GetCurrentIdent("TBL_PRODUCT_FEEDBACK");

        for (int i = 0; i < 10; i++)
        {
            try
            {
                string img = "image" + i;
                HttpPostedFile image_file = mContext.Request.Files[img];
                int rand = r.Next(10000, 99999);
                if (image_file.ContentLength >= 0)
                {
                    string image = DateTime.Now.ToString("yyyyMMddHHmmss");
                    string path = image_path + image + rand + ".png";
                    image_file.SaveAs(path);
                    query.Clear();
                    query.SetTable("TBL_PRODUCT_FEEDBACK_IMAGES");
                    query.AddColumn("PRODUCT_FEEDBACK_NO", report_id);
                    query.AddColumn("image_path", image + rand + ".png");
                    db.Execute(query.InsertQuery());
                }
            }
            catch (Exception ex)
            {

            }
        }

        try
        {
            int rand = r.Next(10000, 99999);
            string video = DateTime.Now.ToString("yyyyMMddHHmmss");
            HttpPostedFile video_file = mContext.Request.Files["video"];
            video_file.SaveAs(video_path + video + rand + ".mp4");
            query.Clear();
            query.SetTable("TBL_PRODUCT_FEEDBACK_VIDEOS");
            query.AddColumn("PRODUCT_FEEDBACK_NO", report_id);
            query.AddColumn("VIDEO_PATH", video + rand + ".mp4");
            db.Execute(query.InsertQuery());
        }
        catch (Exception ex)
        {

        }

    }
    private void getProductCategoryName()
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT_CATEGORY");
        query.AddColumn("CATEGORY_NAME");
        query.AddCondition("NO=" + drOrder["PRODUCT_CATEGORY_NO"].ToString());
        drCategroyName = db.GetDataRow(query.SelectQuery());

    }



    /// <summary>
    /// 更新订单状态
    /// </summary>
    private void updateOrderState()
    {

        if (drOrder["ORDER_STATE"].ToString().Equals("3"))
        {
            query.Clear();
            query.SetTable("TBL_USER_ORDER");
            query.AddColumn("ORDER_STATE", "6");
            query.AddColumn("FEEDBACK_NO", report_id);
            query.AddColumn("FEEDBACK_PROCESS_STATE", "1");
            query.AddColumn("COMMIT_FEEDBACK_DATE", DateTime.Now.ToString("yyyy-MM-dd"));
            query.AddCondition("ORDER_NO='" + order_id + "'");
            db.Execute(query.UpdateQuery());
            db.Commit();
            strResult.Clear();
            JsonUtil.setJson3(strResult, "report_id", report_id);
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
        }
        else
        {
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60086");
            db.Rollback();
            return;
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