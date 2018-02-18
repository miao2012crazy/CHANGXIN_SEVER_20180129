using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppCommon;
using System.Data;

public partial class AppAdmin_Address_management : System.Web.UI.Page
{
    public DataRow dr = null;
    //连接数据库
    private Database db = new Database();
    //查询数据
    private Query query = new Query();
    //声明变量
    public DataRowCollection drc = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        db.Connect();
        try
        {
            //清理数据库
            query.Clear();
            //查询表
            query.SetTable("TBL_USER_ADDRESS");
            //查询所有数据
            query.AddColumn("*");
            //查询数据
            drc = db.GetDataRows(query.SelectQuery());
            if (!IsPostBack)
            {
                //查询整个表格的数据
                DataTable dt = db.GetDataTable(query.SelectQuery());
                Repeater1.DataSource = dt;
                Repeater1.DataBind();//绑定数据
            }

        }
        catch (Exception ex)
        {
        }
        finally
        {
            db.Close();
        }



    }
}