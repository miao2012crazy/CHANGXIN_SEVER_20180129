<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Address_management.aspx.cs" Inherits="AppAdmin_Address_management" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>地址管理</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="这是一个 地址管理 页面">
    <meta name="keywords" content="index">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <meta name="apple-mobile-web-app-title" content="Amaze UI" />
    <link rel="stylesheet" href="assets/css/amazeui.min.css" />
    <link rel="stylesheet" href="assets/css/amazeui.datatables.min.css" />
    <link rel="stylesheet" href="assets/css/app.css">
    <link rel="stylesheet" href="assets/css/amazeui.css">
    <link rel="stylesheet" href="assets/css/amazeui.css">
    <link rel="stylesheet" href="css/Admin.css" />
    <link rel="stylesheet" href="css/reset.css" />
    <script src="assets/js/jquery.min.js"></script>
    <script src="scripts/jquery.min.js"></script>
    <style>
        th, td {
            text-align: center;
            color: #000000;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <script src="assets/js/theme.js"></script>
        <div class="am-g tpl-g">
            <%-- 头部--%>
            <header>
                <%--logo --%>
                <div class="am-fl tpl-header-logo">
                    <a href="javascript:;">
                        <img src="assets/img/logo.png" alt=""></a>
                </div>
                <%-- 右侧内容--%>
                <div class="tpl-header-fluid">
                    <%-- 侧边切换 --%>
                    <div class="am-fl tpl-header-switch-button am-icon-list">
                        <span></span>
                    </div>
                    <%--搜索--%>
                    <div class="am-fl tpl-header-search index_search">
                        <button class="tpl-header-search-btn am-icon-search"></button>
                        <input class="tpl-header-search-box" type="text" placeholder="输入想要查找的内容......">
                    </div>
                    <%--其它功能--%>
                    <div class="am-fr tpl-header-navbar">
                        <ul>
                            <%--欢迎语--%>
                            <li class="am-text-sm tpl-header-navbar-welcome">
                                <a href="javascript:;">你好,<span>管理员</span> </a>
                            </li>

                            <%--退出--%>
                            <li class="am-text-sm">
                                <a href="javascript:;">
                                    <span class="am-icon-sign-out"></span>退出
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

            </header>
            <%--风格切换--%>
            <div class="tpl-skiner">
                <div class="tpl-skiner-toggle am-icon-cog">
                </div>
                <div class="tpl-skiner-content">
                    <div class="tpl-skiner-content-title">
                        选择主题
                    </div>
                    <div class="tpl-skiner-content-bar">
                        <span class="skiner-color skiner-white" data-color="theme-white"></span>
                        <span class="skiner-color skiner-black" data-color="theme-black"></span>
                    </div>
                </div>
            </div>
            <%--侧边导航栏--%>
            <div class="left-sidebar">
                <%--用户信息--%>
                <div class="tpl-sidebar-user-panel">
                    <div class="tpl-user-panel-slide-toggleable">
                        <div class="tpl-user-panel-profile-picture">
                            <img src="assets/img/user04.png" alt="">
                        </div>
                        <span class="user-panel-logged-in-text">
                            <i class="am-icon-circle-o am-text-success tpl-user-panel-status-icon"></i>
                            王大力
                        </span>
                        <a href="javascript:;" class="tpl-user-panel-action-link"><span class="am-icon-pencil"></span>13662148367</a>
                    </div>
                </div>


                <%--菜单--%>
                <ul class="sidebar-nav">
                    <%--系统管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/xitong.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">产品管理</span>
                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="Uploading_products.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>上传产品
                                </a>

                                <a href="Product_list.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>产品列表
                                </a>
                                <a href="Address_management.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>地址管理
                                </a>
                            </li>
                        </ul>
                    </li>


                    <%--运营管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/yunying.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">运营管理</span>
                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="Exchange_rate.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>汇率管理
                                </a>
                            </li>

                            <li class="sidebar-nav-link">
                                <a href="Customer.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>客户管理
                                </a>
                            </li>

                            <li class="sidebar-nav-link">
                                <a href="Known.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>IB管理
                                </a>
                            </li>

                            <li class="sidebar-nav-link">
                                <a href="#">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>公知管理
                                </a>
                            </li>

                            <li class="sidebar-nav-link">
                                <a href="ib_video.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>IB视频管理
                                </a>m 
                            </li>

                        </ul>
                    </li>


                    <%--产品管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/chanpin.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">产品管理</span>
                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="#">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>分类管理
                                </a>
                            </li>

                            <li class="sidebar-nav-link">
                                <a href="product.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>产品管理
                                </a>
                            </li>

                            <li class="sidebar-nav-link">
                                <a href="Product_operation.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>产品运营
                                </a>
                            </li>

                        </ul>
                    </li>


                    <%--订单管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/dingdan.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">订单管理</span>



                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="Order.aspx">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>订单
                                </a>
                            </li>
                        </ul>
                    </li>

                    <%--出库管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/chuku.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">出库管理</span>
                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="#">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>配送管理
                                </a>
                            </li>
                        </ul>
                    </li>




                    <%--取消订单管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/quxiao.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">取消订单管理</span>
                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="#">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>取消管理
                                </a>
                            </li>
                        </ul>
                    </li>

                    <%--结算管理--%>
                    <li class="sidebar-nav-link">
                        <a href="javascript:;" class="sidebar-nav-sub-title">
                            <img src="img/jiesuan.png" style="margin-right: 10px; padding-bottom: 5px;" />
                            <span style="font-size: 17px;">结算管理</span>
                            <span class="am-icon-chevron-down am-fr am-margin-right-sm sidebar-nav-sub-ico"></span>
                        </a>
                        <ul class="sidebar-nav sidebar-nav-sub">
                            <li class="sidebar-nav-link">
                                <a href="#">
                                    <span class="am-icon-angle-right sidebar-nav-link-logo"></span>准备结算
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>

            <%--内容区域--%>
            <div class="tpl-content-wrapper">
                <%-- 当前位置 --%>
                <div class="Employee_nav">
                    <img class="Emp_position_img" src="img/position.png" />
                    <span class="Emp_position_txt">当前位置:</span>
                    <ul class="Emp_position_ul">
                        <li>产品管理></li>
                        <li style="font-weight: 600; color: #ff0000">地址管理</li>
                    </ul>
                </div>
                <%-- 产品列表 --%>
                <div class="list_product_div">
                    <asp:Repeater ID="Repeater1" runat="server">
                        <HeaderTemplate>
                            <table class="am-table am-table-hover table-main">
                                <thead>
                                    <tr class="am-danger">
                                        <th>编号</th>
                                        <th>用户地址状态  </th>
                                        <th>Admin</th>
                                        <th>is_DEFAULT</th>
                                        <th>[ADDRESS_TITLE]</th>
                                        <th>地址区域</th>
                                        <th>详细地址</th>
                                        <th>用户姓名</th>
                                        <th>联系电话</th>
                                        <th>注册日期</th>
                                    </tr>
                                </thead>
                        </HeaderTemplate>
                        <%--itemtemplate模板 输出数据行数 --%>
                        <ItemTemplate>
                            <%-- <tbody>--%>
                            <%--绑定输出的列--%>
                            <tr class="am-table-hover">
                                <td><%# Eval("NO").ToString() %></td>
                                <td><%# Eval("USER_ADDRESS_STATE").ToString() %></td>
                                <td><%# Eval("USER_NO").ToString() %></td>
                                <td><%# Eval("IS_DEFAULT").ToString() %></td>
                                <td><%# Eval("ADDRESS_TITLE").ToString() %></td>
                                <td><%# Eval("ADDRESS_DETAIL1").ToString() %></td>
                                <td><%# Eval("ADDRESS_DETAIL2").ToString() %></td>
                                <td><%# Eval("RECV_NAME").ToString() %></td>
                                <td><%# Eval("RECV_TEL").ToString() %></td>
                                <td><%# Eval("REG_DATE").ToString() %></td>
                            </tr>
                            <%--</tbody>--%>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <%-- 分页 --%>

                <ul data-am-widget="pagination" class="am-pagination am-pagination-select" style="width: 200px; margin-left: 0.5%;">
                    <li class="am-pagination-prev ">
                        <a href="#" class="">上一页</a>
                    </li>
                    <li class="am-pagination-select">
                        <select>
                            <option value="#" class="">1
                / 
                            </option>
                            <option value="#" class="">2
                / 
                            </option>
                            <option value="#" class="">3
                / 
                            </option>
                        </select>
                    </li>
                    <li class="am-pagination-next ">
                        <a href="#" class="">下一页</a>
                    </li>
                </ul>
            </div>
        </div>

        <script src="assets/js/amazeui.min.js"></script>
        <script src="assets/js/app.js"></script>
    </form>
</body>
</html>
