using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ProductUtil 的摘要说明
/// </summary>
public class ProductUtil
{
    public ProductUtil()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    /// <summary>
    /// 抢购状态 PRODUCT_EVAL_STATE 
    /// </summary>
    /// <param name="state"></param>
    /// <returns></returns>
    public static string getStateForProduct(string state) {
        switch (state) {
            case "0":
                return "未生效";
            case "1":
                return "已生效";
            case "2":
                return "已下架";
            case "3":
                return "轮播图";
            default:
                return "未生效";
        }

    }

    /// <summary>
    /// 出售状态 PRODUCT_SELL_STATE 
    /// </summary>
    /// <param name="state"></param>
    /// <returns></returns>
    public static string getStateForProductSell(string state)
    {
        switch (state)
        {
         
            case "0":
                return "正在出售";
            case "1":
                return "不出售";
            case "2":
                return "已下架";
           
            default:
                return "未生效";
        }

    }


    public static string getCashState(string state) {

        switch (state)
        { 
            case "0":
                return "完全退款";
            case "1":
                return "部分退款";
           default:
                return "无退款";
        }

    }

    public static string getLoopState(string state)
    {
        switch (state)
        {
            case "0":
                return "不是轮播图";
            case "1":
                return "是轮播图";
            default:
                return "";
        }


    }




}