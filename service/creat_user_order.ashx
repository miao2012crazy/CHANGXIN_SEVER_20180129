<%@ WebHandler Language="C#" Class="creat_user_order" %>

using System;
using System.Web;
using AppCommon;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;

/// <summary>
//1     获取用户实名认证状态
//2     获取产品相关信息
//3     获取用户地址信息
//4     计算含税价格
//5     计算商品总价格
//6     计算订单总价格
//7     查询TBL_PRODUCT 是否为0  如果剩余数量为0 下单失败 库存不足
//8     先取出一个  更新TBL_PRODUCT 数量-1;(开启事务)
//9     规整数据 生成订单 插入数据库 使用商品id+时间戳的形式生成订单id
//10    失败回滚RollBack;
/// </summary>
public class creat_user_order : IHttpHandler
{
    private DataRow dr;
    private Database db = new Database();
    private Query query = new Query();
    private StringBuilder strResult = new StringBuilder();
    private string resopnse = "";
    private string result = "";
    private HttpContext mContext;
    private string product_id;
    private string user_id;
    private string recv_address_id;
    private string order_message;
    private DataRow drUser = null;
    private DataRow drProduct = null;
    private DataRow drRecvUser = null;
    public void ProcessRequest(HttpContext context)
    {
        this.mContext = context;
        string key = context.Request.Form["key"];
        string body = context.Request.Form["body"];
        try
        {

            result = RSAFromPkcs8.decryptData(key, RSAConfig.PRIVATEKEY);
            string json = AES.Decrypt(body, result, "");
            JObject obj = JObject.Parse(json.Split('#')[0]);

            product_id = obj["product_id"].ToString();
            user_id = obj["user_id"].ToString();
            recv_address_id = obj["recv_address_id"].ToString();

            try
            {
                order_message = obj["order_message"].ToString();
            }
            catch { }
        }
        catch (Exception ex)
        {
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60078");
            return;
        }

        try
        {
            db.Connect();
            getUserInfo();
            getProductInfo();
            getRecvAddress();
            if (drUser == null) return;
            if (drProduct == null) return;
            if (drRecvUser == null) return;
            creatOrder();

        }
        catch (Exception ex)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60057");
        }
        finally
        {
            strResult.Clear();
            string res = AES.Encrypt(resopnse, result, "");
            context.Response.Write(res);
            try { db.Close(); } catch { }

        }
    }



    private void creatOrder()
    {
        //税
        float tax_price = PriceUtil.getProductTax(drProduct["PRODUCT_TAX_PERCENT"].ToString(), drProduct["PRODUCT_PRICE"].ToString());
        //运费
        float shipment_price = PriceUtil.getProductTax(drProduct["PRODUCT_SHIPMENT_PRICE"].ToString(), "0.00");
        //商品总价值
        float product_total_price = PriceUtil.getOrderPrice(tax_price, shipment_price, drProduct["PRODUCT_PRICE"].ToString());
        //申请商品剩余数量出售数量+1 申请之后查询 剩余数量 如果小于0  数据回滚
        try
        {
            db.BeginTransaction();
            int sellCount = int.Parse(drProduct["PRODUCT_MINSELL_STOCK"].ToString()) + 1;
            db.Execute("UPDATE TBL_PRODUCT SET PRODUCT_MINSELL_STOCK='" + sellCount + "' WHERE PRODUCT_CODE='" + product_id + "'");
            int overplus = db.GetOneInt("SELECT TBL_PRODUCT.PRODUCT_MINSELL_STOCK FROM TBL_PRODUCT WHERE PRODUCT_CODE='" + product_id + "'");

            //mContext.Response.Write(drProduct["PRODUCT_STOCK"].ToString());
            //return;
            if (overplus > int.Parse(drProduct["PRODUCT_STOCK"].ToString()))
            {
                db.Rollback();
                strResult.Clear();
                resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60083");
                return;
            }
            //申请成功
            //开始创建订单 初始化订单号
            Random r = new Random(BitConverter.ToInt32(Guid.NewGuid().ToByteArray(), 0));

            string order_id = DateTime.Now.ToString("yyyyMMddHHmmss") + r.Next(10000000, 99999999).ToString();
            //mContext.Response.Write("出售终止日期"+drProduct["PRODUCT_SELL_END"].ToString());
            query.Clear();
            query.SetTable("TBL_USER_ORDER");
            query.AddColumn("ORDER_NO", order_id);
            query.AddColumn("ORDER_PRICE", product_total_price.ToString());
            query.AddColumn("ORDER_WEIGHT", "0.00");
            query.AddColumn("ORDER_STATE", "0");//全部订单提交时 默认为待付款状态
            query.AddColumn("PRODUCT_TAX_PRICE", tax_price.ToString());
            query.AddColumn("PRODUCT_TAX_PERCENT", drProduct["PRODUCT_TAX_PERCENT"].ToString());
            query.AddColumn("USER_ADDRESS_STATE", drRecvUser["USER_ADDRESS_STATE"].ToString());
            query.AddColumn("USER_NO", drUser["ID"].ToString());
            query.AddColumn("USER_REAL_NAME", drUser["REAL_NAME"].ToString());
            query.AddColumn("USER_REAL_NUM", drUser["IDEN_NO"].ToString());
            query.AddColumn("PRODUCT_CODE", drProduct["PRODUCT_CODE"].ToString());
            query.AddColumn("PRODUCT_CATEGORY_NO", drProduct["PRODUCT_CATEGORY_NO"].ToString());
            query.AddColumn("PRODUCT_HS_CODE", drProduct["PRODUCT_HS_CODE"].ToString());
            query.AddNVColumn("PRODUCT_NAME", drProduct["PRODUCT_NAME"].ToString());
            query.AddColumn("PRODUCT_WEIGHT", "0");//商品重量暂时填0
            query.AddNVColumn("PRODUCT_ORIGINAL_NAME", drProduct["PRODUCT_ORIGINAL_NAME"].ToString());
            query.AddNVColumn("PRODUCT_DESC", drProduct["PRODUCT_DESC"].ToString());
            query.AddNVColumn("PRODUCT_BRAND", drProduct["PRODUCT_BRAND"].ToString());
            query.AddNVColumn("PRODUCT_MANUFACTURER", drProduct["PRODUCT_MANUFACTURER"].ToString());
            query.AddNVColumn("PRODUCT_EVAL_DEPOSIT", drProduct["PRODUCT_EVAL_DEPOSIT"].ToString());
            query.AddNVColumn("PRODUCT_EVAL_DEPOSIT_REFUND", drProduct["PRODUCT_EVAL_DEPOSIT_REFUND"].ToString());
            query.AddNVColumn("PRODUCT_EVAL_DEPOSIT_REFUND_RATE", drProduct["PRODUCT_EVAL_DEPOSIT_REFUND_RATE"].ToString());
            query.AddNVColumn("PRODUCT_ORIGIN_PRICE", drProduct["PRODUCT_ORIGIN_PRICE"].ToString());
            query.AddNVColumn("PRODUCT_PRICE", drProduct["PRODUCT_PRICE"].ToString());
            query.AddNVColumn("PRODUCT_SHIPMENT_PRICE", drProduct["PRODUCT_SHIPMENT_PRICE"].ToString());
            query.AddNVColumn("PRODUCT_DETAIL1", drProduct["PRODUCT_DETAIL1"].ToString());
            query.AddNVColumn("PRODUCT_IMAGE1", drProduct["PRODUCT_IMAGE1"].ToString());
            query.AddNVColumn("PRODUCT_EVAL_WEEKS", drProduct["PRODUCT_EVAL_WEEKS"].ToString());
            //日期这里有错误
            //query.AddNVColumn("PRODUCT_EVAL_START", drProduct["PRODUCT_EVAL_START"].ToString());
            //query.AddNVColumn("PRODUCT_EVAL_EBD", drProduct["PRODUCT_EVAL_EBD"].ToString());
            query.AddNVColumn("PRODUCT_SELL_WEEKS", drProduct["PRODUCT_SELL_WEEKS"].ToString());
            //query.AddNVColumn("PRODUCT_SELL_START", drProduct["PRODUCT_SELL_START"].ToString());
            //query.AddNVColumn("PRODUCT_SELL_END", drProduct["PRODUCT_SELL_END"].ToString());
            query.AddNVColumn("ADDRESS_DETAIL1", drRecvUser["ADDRESS_DETAIL1"].ToString());
            query.AddNVColumn("ADDRESS_DETAIL2", drRecvUser["ADDRESS_DETAIL2"].ToString());
            query.AddNVColumn("RECV_NAME", drRecvUser["RECV_NAME"].ToString());
            query.AddNVColumn("RECV_TEL", drRecvUser["RECV_TEL"].ToString());
            if (order_message != null && order_message != "")
            {
                query.AddNVColumn("ORDER_MESSAGE", order_message);
            }

            db.Execute(query.InsertQuery());
            db.Commit();
            resopnse = JsonUtil.setJsonResult_new_2("S", strResult, "");
        }
        catch (Exception ex)
        {
            //mContext.Response.Write(ex.Message);
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60084");
            db.Rollback();
        }
    }


    /// <summary>
    /// 获取用户信息
    /// </summary>
    private void getUserInfo()
    {
        query.Clear();
        query.SetTable("TBL_USER");
        query.AddColumn("*");
        query.AddCondition("ID='" + user_id + "'");
        drUser = db.GetDataRow(query.SelectQuery());
        if (drUser["USER_REAL_STATE"].ToString().Equals("1"))
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60070");
            drUser = null;
        }
    }
    /// <summary>
    /// 获取商品信息
    /// </summary>
    private void getProductInfo()
    {
        query.Clear();
        query.SetTable("TBL_PRODUCT");
        query.AddColumn("*");
        query.AddCondition("PRODUCT_CODE='" + product_id + "'");
        drProduct = db.GetDataRow(query.SelectQuery());
        if (drProduct == null)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60077");
            drProduct = null;
        }
    }
    /// <summary>
    /// 获取收货人信息
    /// </summary>
    private void getRecvAddress()
    {
        query.Clear();
        query.SetTable("TBL_USER_ADDRESS");
        query.AddColumn("*");
        query.AddCondition("NO='" + recv_address_id + "'");
        drRecvUser = db.GetDataRow(query.SelectQuery());
        if (drRecvUser == null)
        {
            strResult.Clear();
            resopnse = JsonUtil.setJsonResult_new_2("F", strResult, "60067");
            drRecvUser = null;
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