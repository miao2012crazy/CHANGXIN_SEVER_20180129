using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// PriceUtil 的摘要说明
/// </summary>
public class PriceUtil
{
    public PriceUtil()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    /// <summary>
    /// 获取单个商品需要上税金额
    /// </summary>
    /// <param name="tax_percent">上税百分比</param>
    /// <param name="product_price">商品价格</param>
    /// <returns></returns>
    public static float getProductTax(string tax_percent, string product_price)
    {
        float tax_price = float.Parse(tax_percent) * float.Parse(product_price);
        return float.Parse(string.Format("{0:0.00}", tax_price/100));
    }
    /// <summary>
    /// 获取商品的运费
    /// </summary>
    /// <param name="product_shipment"> 运费(默认) </param>
    /// <param name="product_weight"> 商品重量 </param>
    /// <returns></returns>
    public static float getShipmentPrice(string product_shipment, string product_weight)
    {
        float shipment_price = float.Parse(product_shipment);
        return float.Parse(string.Format("{0:0.00}", shipment_price));
    }
    /// <summary>
    /// 计算订单总价格  税+运费+商品价格
    /// </summary>
    /// <param name="tax_price"></param>
    /// <param name="shipment_price"></param>
    /// <param name="product_price"></param>
    /// <returns></returns>
    public static float getOrderPrice(float tax_price, float shipment_price, string product_price)
    {
        float product_total_price = tax_price + shipment_price + float.Parse(string.Format("{0:0.00}", product_price)) ;
        return float.Parse(string.Format("{0:0.00}", product_total_price));
    }




}