using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Google.ProtocolBuffers;
using com.gexin.rp.sdk.dto;
using com.igetui.api.openservice;
using com.igetui.api.openservice.igetui;
using com.igetui.api.openservice.igetui.template;
using com.igetui.api.openservice.payload;
using System.Net;

namespace AppCommon
{/// <summary>
/// 个推 推送 服务端
/// </summary>
    public class PushUtil
    {
        //http的域名
        private static String HOST = "http://sdk.open.api.igexin.com/apiex.htm";

        //https的域名
        //private static String HOST = "https://api.getui.com/apiex.htm";

        //定义常量, appId、appKey、masterSecret 采用本文档 "第二步 获取访问凭证 "中获得的应用配置
        private static String APPID = "WBjMMI3rRb75y2bMe27ei5";
        private static String APPKEY = "zek9nVJ3iQ8yMCor6tJqH6";
        private static String MASTERSECRET = "diuwRpFA0VAH0MT4MJTjVA";
        private static String CLIENTID = "9eadea172d1ec0fbe71377efa3a42bd2";
        private static String CLIENTID1 = "9eadea172d1ec0fbe71377efa3a42bd2";
        private static String CLIENTID2 = "9eadea172d1ec0fbe71377efa3a42bd2";

        private static String DeviceToken = "";  //填写IOS系统的DeviceToken
        /// <summary>
        /// 对单个用户的推送
        /// </summary>
        /// <returns></returns>
        public static string PushMessageToSingle()
        {

            IGtPush push = new IGtPush(HOST, APPKEY, MASTERSECRET);
            //消息模版：网页模板
            LinkTemplate template = LinkTemplateDemo();
            // 单推消息模型
            SingleMessage message = new SingleMessage();
            // 用户当前不在线时，是否离线存储,可选
            message.IsOffline = true;
            // 离线有效时间，单位为毫秒，可选                
            message.OfflineExpireTime = 1000 * 3600 * 12;
            message.Data = template;
            com.igetui.api.openservice.igetui.Target target = new com.igetui.api.openservice.igetui.Target();
            target.appId = APPID;
            target.clientId = CLIENTID;
            //target.alias = ALIAS;
            try
            {
                string pushResult = push.pushMessageToSingle(message, target);
                return "发送成功" + pushResult;
                //System.Console.WriteLine("-----------------------------------------------");
                //System.Console.WriteLine("-----------------------------------------------");
                //System.Console.WriteLine("----------------服务端返回结果：" + pushResult);
            }
            catch (RequestException e)
            {
                string requestId = e.RequestId;

                //发送失败后的重发
                string pushResult = push.pushMessageToSingle(message, target, requestId);
                return "失败重发" + pushResult;
                //System.Console.WriteLine("-----------------------------------------------");
                //System.Console.WriteLine("-----------------------------------------------");
                //System.Console.WriteLine("----------------服务端返回结果：" + pushResult);
            }
        }

        //PushMessageToList接口测试代码
        /// <summary>
        /// 对指定列表用户推送
        /// </summary>
        private static void PushMessageToList()
        {
            // 推送主类（方式1，不可与方式2共存）
            IGtPush push = new IGtPush(HOST, APPKEY, MASTERSECRET);
            // 推送主类（方式2，不可与方式1共存）此方式可通过获取服务端地址列表判断最快域名后进行消息推送，每10分钟检查一次最快域名
            //IGtPush push = new IGtPush("",APPKEY,MASTERSECRET);
            ListMessage message = new ListMessage();

            LinkTemplate template = LinkTemplateDemo();
            // 用户当前不在线时，是否离线存储,可选
            message.IsOffline = true;
            // 离线有效时间，单位为毫秒，可选
            message.OfflineExpireTime = 1000 * 3600 * 12;
            message.Data = template;
            message.PushNetWorkType = 0;        //判断是否客户端是否wifi环境下推送，1为在WIFI环境下，0为不限制网络环境。
            //设置接收者
            List<com.igetui.api.openservice.igetui.Target> targetList = new List<com.igetui.api.openservice.igetui.Target>();
            com.igetui.api.openservice.igetui.Target target1 = new com.igetui.api.openservice.igetui.Target();
            target1.appId = APPID;
            target1.clientId = CLIENTID;

            // 如需要，可以设置多个接收者
            //com.igetui.api.openservice.igetui.Target target2 = new com.igetui.api.openservice.igetui.Target();
            //target2.AppId = APPID;
            //target2.ClientId = "ddf730f6cabfa02ebabf06e0c7fc8da0";

            targetList.Add(target1);
            //targetList.Add(target2);

            String contentId = push.getContentId(message);
            String pushResult = push.pushMessageToList(contentId, targetList);
            System.Console.WriteLine("-----------------------------------------------");
            System.Console.WriteLine("服务端返回结果:" + pushResult);
        }


        //pushMessageToApp接口测试代码
        /// <summary>
        /// 对指定应用群推送
        /// </summary>
        private static void pushMessageToApp()
        {
            // 推送主类（方式1，不可与方式2共存）
            IGtPush push = new IGtPush(HOST, APPKEY, MASTERSECRET);
            // 推送主类（方式2，不可与方式1共存）此方式可通过获取服务端地址列表判断最快域名后进行消息推送，每10分钟检查一次最快域名
            //IGtPush push = new IGtPush("",APPKEY,MASTERSECRET);

            AppMessage message = new AppMessage();

            // 设置群推接口的推送速度，单位为条/秒，仅对pushMessageToApp（对指定应用群推接口）有效
            message.Speed = 100;

            LinkTemplate template = LinkTemplateDemo();

            // 用户当前不在线时，是否离线存储,可选
            message.IsOffline = false;
            // 离线有效时间，单位为毫秒，可选  
            message.OfflineExpireTime = 1000 * 3600 * 12;
            message.Data = template;
            //message.PushNetWorkType = 0;        //判断是否客户端是否wifi环境下推送，1为在WIFI环境下，0为不限制网络环境。
            List<String> appIdList = new List<string>();
            appIdList.Add(APPID);

            //通知接收者的手机操作系统类型
            List<String> phoneTypeList = new List<string>();
            //phoneTypeList.Add("ANDROID");
            //phoneTypeList.Add("IOS");
            //通知接收者所在省份
            List<String> provinceList = new List<string>();
            //provinceList.Add("浙江");
            //provinceList.Add("上海");
            //provinceList.Add("北京");

            List<String> tagList = new List<string>();
            //tagList.Add("开心");

            message.AppIdList = appIdList;
            message.PhoneTypeList = phoneTypeList;
            message.ProvinceList = provinceList;
            message.TagList = tagList;


            String pushResult = push.pushMessageToApp(message);
            System.Console.WriteLine("-----------------------------------------------");
            System.Console.WriteLine("服务端返回结果：" + pushResult);
        }
        //网页模板内容
        public static LinkTemplate LinkTemplateDemo()
        {
            LinkTemplate template = new LinkTemplate();
            template.AppId = APPID;
            template.AppKey = APPKEY;
            //通知栏标题
            template.Title = "请填写通知标题";
            //通知栏内容 
            template.Text = "请填写通知内容";
            //通知栏显示本地图片 
            template.Logo = "";
            //通知栏显示网络图标，如无法读取，则显示本地默认图标，可为空
            template.LogoURL = "";
            //打开的链接地址    
            template.Url = "http://www.baidu.com";
            //接收到消息是否响铃，true：响铃 false：不响铃   
            template.IsRing = true;
            //接收到消息是否震动，true：震动 false：不震动   
            template.IsVibrate = true;
            //接收到消息是否可清除，true：可清除 false：不可清除
            template.IsClearable = true;
            return template;
        }

       

    }
}
