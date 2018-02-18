<%@ WebHandler Language="C#" Class="commit_report_experience" %>

using System;
using System.Web;
using System.IO;
using AppCommon;
using System.Data;
using System.Text;
public class commit_report_experience : IHttpHandler
{
    private string report_id = "";
    private string user_id = "";
    private Random r = new Random(BitConverter.ToInt32(Guid.NewGuid().ToByteArray(), 0));
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private HttpContext mContext;
    private string result = "";
    private string resopnse = "";
    private string feedback_experience = "";
    private string image_path = "";

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            this.mContext = context;
            user_id = context.Request.Form["user_id"];
            report_id = context.Request.Form["report_id"];
            if (report_id == null || report_id == "")
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60090");
                return;
            }
            image_path = context.Server.MapPath("../Storage/report/" + user_id + "/experience/");
            if (Directory.Exists(image_path) == false)
            {
                Directory.CreateDirectory(image_path);
            }
            //获取试用过程 
            feedback_experience = mContext.Request.Form["feedback_experience"];


            db.Connect();
            query.Clear();
            query.SetTable("TBL_PRODUCT_FEEDBACK");
            query.AddColumn("*");
            query.AddCondition("NO=" + report_id);
            DataRow dr = db.GetDataRow(query.SelectQuery());
            if (dr == null)
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60087");
                return;
            }
            if (!dr["USER_ID"].ToString().Equals(user_id))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60088");
                return;

            }
            if (feedback_experience.Equals(""))
            {
                resopnse = JsonUtil.setJsonResult_new("F", strResult, "60089");
                return;
            }
            db.BeginTransaction();
            query.Clear();
            query.SetTable("TBL_PRODUCT_FEEDBACK");
            query.AddColumn("EXPERIENCE", feedback_experience);
            query.AddCondition("NO=" + report_id);
            db.Execute(query.UpdateQuery());
            getImageAndVideo();
            db.Commit();
            resopnse = JsonUtil.setJsonResult_new("S", strResult, "");
        }
        catch
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new("F", strResult, "60057");
        }
        finally
        {
            context.Response.Write(resopnse);
            try
            {
                db.Close();
            }
            catch { }
        }
    }



    /// <summary>
    /// 获取视频和照片 插入表
    /// </summary>
    private void getImageAndVideo()
    {
        for (int i = 0; i < 3; i++)
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
                    query.SetTable("TBL_PRODUCT_FEEDBACK_EXPERIENCE_IMAGES");
                    query.AddColumn("PRODUCT_FEEDBACK_NO", report_id);
                    query.AddColumn("image_path", image + rand + ".png");
                    db.Execute(query.InsertQuery());
                }
            }
            catch (Exception ex)
            {

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