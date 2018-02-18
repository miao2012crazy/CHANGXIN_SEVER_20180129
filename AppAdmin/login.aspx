<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="AppAdmin_login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>登录</title>
    <link rel="stylesheet" href="css/Admin.css" />
    <script src="scripts/BTVADMIN_SEVER.js"></script>
    <script src="scripts/jquery.min.js"></script>
    <script>
        /* if 5 minutes no operation then logout --liaotuo@2017.8.20 */
        var maxTime = 1800; // seconds
        var time = maxTime;
        $('body').on('keydown mousemove mousedown', function (e) {
            time = maxTime; // reset
        });
        var intervalId = setInterval(function () {
            time--;
            if (time <= 0) {
                ShowInvalidLoginMessage();
                clearInterval(intervalId);
            }
        }, 1800)
        function ShowInvalidLoginMessage() {
            alert("您已经长时间没操作了，即将退出系统");
            //TODO 做需要做的操作
            //exp:关闭页面
            window.close();
        }
    </script>
</head>
<body>
   <form id="form1" runat="server">
        <div class="loginDiv">
            <%-- 登录模块底板 --%>
            <div class="loginFoot">
                <%-- 提示文字 --%>
                <div class="goumeiName" align="center">
                    <img src="img/goumeiAdmin.png" class="goumeiImg" />
                </div>

                <%-- 用户id和密码Div --%>
                <div class="inputDiv">
                    <%-- 用户id --%>
                    <div class="userDiv">
                        <input type="text" id="inputID" class="inputID" placeholder="请输入用户ID" />
                    </div>

                    <%-- 用户pwd --%>     
                    <div class="userDiv">
                        <input type="password"  id="inputPwd" class="inputPwd" placeholder="请输入密码" />
                    </div>
                </div>

                <%-- 登录按钮 --%>
                <div class="loginBtn">
                    <button class="sign_iput" type="submit" name="#" value="" onclick="bt_clien()">登录</button>
                </div>
            </div>
            <%--loginFoot结尾--%>
        </div>
    </form>
    <script>
        function bt_clien() {
            var uid = document.getElementById("inputID");
            var psd = document.getElementById("inputPwd");
            var data = "";
            data += "uid:" + uid.value;
            data += "#"
            data += "psd:" + psd.value;
            BTVADMIN_POST("login.aspx/search_login", data, "success");
            //存储数据
            var uid1 = uid.value();
            var psd1 = psd.value();
            sessionStorage.setItem("uid2", uid1);
            sessionStorage.setItem("pwd2", psd1);
           
            }
            
        //请求成功以后执行的方法
        function success(data){
           
             }
    </script>
</body>
</html>
