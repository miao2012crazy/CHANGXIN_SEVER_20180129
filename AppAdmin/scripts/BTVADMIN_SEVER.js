/**
*   公用网络请求接口 
*/
function BTVADMIN_POST(url, data, fn, obj) {
    var paramas = getParamas(data);
    $.ajax({
        type: "POST",
        contentType: "application/json",
        url: url,
        data: paramas,
        dataType: "json",
        success: function (data) {
            var result = check_data(data.d);
            //请求数据成功
            if (result != null) {
                window[fn].call(this, data);
            }
        }
    });
}
///
///拼接参数
///
function getParamas(data) {
    var paramas = "";
    paramas += "{";
    var strs = new Array();
    strs = data.split("#");
    for (i = 0; i < strs.length ; i++) {

        var key_val = new Array();
        key_val = strs[i].split(":");
        paramas += "'" + key_val[0] + "'";
        paramas += ":";
        paramas += "'" + key_val[1] + "'";
        if (i != strs.length - 1) {
            paramas += ",";
        }
    }
    paramas += "}";
    return paramas;
}

/**
*   返回码预校验
*/
function check_data(data) {
    var jsonObj = JSON.parse(data);
    switch (jsonObj.code) {
        case "S":
             window.location.href = 'http://61.181.111.115/BTVAdmin_New/Employee.aspx';
             return jsonObj.data;
        case "F":
             alert(getErr_msg(jsonObj.err_msg));
             return null;
        case "T":
            //跳转到登录页面
            return null;
    }
       
}
/*
*获取err_msg
*/
function getErr_msg(err_code) {
    switch (err_code) {
        case "60057":
            return "服务器内部错误!";
        default:
            return "未知的返回码" + err_code;
    }
}

 
