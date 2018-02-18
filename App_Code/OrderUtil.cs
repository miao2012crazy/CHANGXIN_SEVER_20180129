using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// OrderUtil 的摘要说明
/// </summary>
public class OrderUtil
{
    public OrderUtil()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    public static string getOrderState(string order_state)
    {
        switch (order_state)
        {
            case "0":
                return "待付款";
            case "1":
                return "已接单";
            case "2":
                return "运输中";
            case "3":
                return "待测评";
            case "4":
                return "已测评";
            case "5":
                return "已取消";
            case "6":
                return "审核中";
            case "7":
                return "审核已通过";
            case "8":
                return "已退款";
            case "9":
                return "审核未通过";
            default:
                return "";
        }
    }



    public static string getFeedbackState(string order_state)
    {
        switch (order_state)
        {
            case "0":
                return "未提交";
            case "1":
                return "已提交";
            case "2":
                return "审核中";
            case "3":
                return "审核通过";
            case "4":
                return "审核失败";
            default:
                return "";
        }
    }

}