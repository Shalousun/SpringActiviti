&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;smartForm是一款基于jquery和boostrap(使用tooltip做验证提示)开发的表单组件，组件兼容最新的jquery3.0。smartForm设计完全遵循html5的验证，也借鉴其它多款表单验证组件的设计思想，她的目的是使得表单验证简单化，你只需要学些一下html5的原生验证规则即可使用smartForm，当然她还有表单提交功能。
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;smartForm她并不是想取代其它的组件，她只是给你提供一个备选方案，让你更加悦快的完成表单验证和提交工作。
## 功能
  &nbsp;&nbsp;&nbsp;&nbsp;1.遵循html5的验证风格，简单易书写
  &nbsp;&nbsp;&nbsp;&nbsp;2.支持restful远程异步验证，同值输入只发起一次验证请求，减少服务器压力
  &nbsp;&nbsp;&nbsp;&nbsp;3.提供表单异步序列化提交和非异步提交(默认采用异步)
  &nbsp;&nbsp;&nbsp;&nbsp;4.内置常用验证表达式
  &nbsp;&nbsp;&nbsp;&nbsp;5.提供多组开放接口，满足表单验证提交大部分场景

## 使用说明
   &nbsp;&nbsp;&nbsp;&nbsp;**1.需要注意的是smartForm默认采用json字符串提交**
   &nbsp;&nbsp;&nbsp;&nbsp;**2.在需要的使用的页面导入jquery，boostrap，smartForm**
```
<link rel="stylesheet" href="http://apps.bdimg.com/libs/bootstrap/3.3.4/css/bootstrap.css"/>
<script src="http://libs.baidu.com/jquery/1.11.1/jquery.min.js"></script>
<script src="http://apps.bdimg.com/libs/bootstrap/3.3.4/js/bootstrap.min.js"></script>

<body>
    <form>
        <!--Your form-->
    </form>
<script src="/js/smartForm.js"></script>
</body>
```
&nbsp;&nbsp;&nbsp;&nbsp;**Usage 1.快速使用用例**
如果只是常用表单，没有复杂的验证和复杂的提交事件，在表单上加上data-toggle="smartForm"，即可完成表单的验证和提交
        
 ```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="http://apps.bdimg.com/libs/bootstrap/3.3.4/css/bootstrap.css"/>
    <script src="http://libs.baidu.com/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://apps.bdimg.com/libs/bootstrap/3.3.4/js/bootstrap.min.js"></script>
</head>
<body>
<form action="/user/add" method="post" id="myFor" data-toggle="smartForm">
    <label for="name">姓名</label>
    <input type="text" id="name" name="name" title="用户名不能为空" data-maxlength="3" required><br/>
    <label for="phone">手机</label>
    <input type="phone" id="phone" name="phone" title="手机号不能为空" required><br/>
    <label for="email">邮箱</label>
    <input type="email|phone" id="emailOrPhone" name="emailOrPhone" title="只能是邮箱或者电话" required><br/>
    <label for="gender">性别</label>
    <input type="radio" id="gender" name="gender" value="男" title="选择性别" required>男
    <input type="radio" id="gender1" name="gender" value="女" title="选择性别" required>女<br>
    <label>兴趣爱好:</label>
    <input type="checkbox" name="interest" value="basketball"/>篮球
    <input type="checkbox" name="interest" value="swim"/><br>游泳
    <label for="password">密码</label>
    <input type="password" id="password" name="password" pattern="^[\w]{5,18}$" title="密码只能输入5-18字母" required><br/>
    <label for="surePassword">确认密码:</label>
    <input type="text" id="surePassword" name="surePassword" data-eq="#password" title="两次密码不一致"><br>
    <label for="province">省份</label>
    <select name="province" id="province" title="选择一个省份" required>
        <option value="0">==请选择==</option>
        <option value="1">北京</option>
        <option value="2">四川</option>
    </select><br>
    <button type="submit">提交</button>
</form>
<script src="/js/smartForm.js"></script>
</body>
</html>

 ```
后台：由于采用smartForm默认采用json字符串，因此需要在controller接收时使用@RequestBody注解
```
//接收数据的model
public class UserVo {
    //姓名
    private String name;
    //密码
    private String password;
    //手机或电话
    private String emailOrPhone;
    //性别
    private String gender;
    //省份
    private String province;
    //兴趣爱好
    private List<String> interest;
    
    //省略getters and setters
}

//controller
@ResponseBody
@RequestMapping(value="/add",method = RequestMethod.POST)
public CommonResult save(@RequestBody UserVo entity){
    CommonResult result = new CommonResult();
    result.setData(entity);
    result.setSuccess(true);
    return result;
}
```
 &nbsp;&nbsp;&nbsp;&nbsp;*Usage 2.复杂表单验证和提交*
  &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;smartForm开放了自定义验证接口和ajax提交后的回调接口用以满足大绝大多数使用场景


  ```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="http://apps.bdimg.com/libs/bootstrap/3.3.4/css/bootstrap.css"/>
    <script src="http://libs.baidu.com/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://apps.bdimg.com/libs/bootstrap/3.3.4/js/bootstrap.min.js"></script>
</head>
<body>
<form method="post" id="myFor">
    <label for="name">姓名</label>
    <!--使用data-url远程验证用户名是否已经存在-->
    <input type="text" id="name" name="name" title="用户名不能为空" data-url="/user/verify"><br/>
    <label for="phone">手机</label>
    <input type="phone" id="phone" name="phone" title="手机号不能为空" required><br/>
    <label for="emailOrPhone">邮箱</label>
    <input type="email|phone" id="emailOrPhone" name="emailOrPhone" title="只能是邮箱或者电话" required><br/>
    <label for="gender">性别</label>
    <input type="radio" id="gender" name="gender" value="男" title="选择性别" required>男
    <input type="radio" id="gender1" name="gender" value="女" title="选择性别" required>女<br>
    <label>兴趣爱好:</label>
    <input type="checkbox" name="interest" value="basketball"/>篮球
    <input type="checkbox" name="interest" value="swim"/><br>游泳
    <label for="password">密码</label>
    <input type="password" id="password" name="password" pattern="^[\w]{5,18}$" title="密码不正确" required><br/>
    <label for="surePassword">确认密码:</label>
    <input type="text" id="surePassword" name="surePassword" data-eq="#password" title="两次密码不一致" required><br>
    <label for="province">省份</label>
    <select name="province" id="province" title="选择一个省份" required>
        <option value="0">==请选择==</option>
        <option value="1">北京</option>
        <option value="2">四川</option>
    </select><br>
    <label for="desc">描述</label>
    <textarea name="desc" id="desc" cols="30" rows="10" placeholder="只能输入10个字符" data-maxlength="10">
    </textarea><br>
    <button type="submit">提交</button>
</form>
<script src="/js/smartForm.js"></script>
<script>
    $("#myFor").smartForm({
        url: '/user/add',
        validate: function () {
            //额外验证
            if ($("input[type='checkbox']:checked").length < 2) {
                $("#color").tip("必须选择两个兴趣爱好");//smartForm内置的提示工具
                return false;
            }
            return true;
        },
        beforeSubmit: function (params) {
            //额外参数
            params.userType = 'normal'
        },
        done: function (result) {
            //表单提交成功后要做的事
            console.log(JSON.stringify(result));
        },
        fail: function () {
            //表单提交失败后的事件
            console.log("error");
        },
        always: function () {
            //无论如何都做的事
            console.log("无论如何都执行");
        }
    })
</script>
</body>
</html>
  ```
&nbsp;&nbsp;后台：spring mvc

```
 //接收数据的model
public class UserVo {
    //姓名
    private String name;
    //密码
    private String password;
    //手机或电话
    private String emailOrPhone;
    //性别
    private String gender;
    //省份
    private String province;
    //兴趣爱好
    private List<String> interest;
    
    //省略getters and setters
}

//controller
@ResponseBody
@RequestMapping(value="/add",method = RequestMethod.POST)
public CommonResult save(@RequestBody UserVo entity){
    CommonResult result = new CommonResult();
    result.setData(entity);
    result.setSuccess(true);
    return result;
}

/**
 * restful api验证用户名是否存在,需要处理中文乱码
 * @param name
 * 	用户名
 * @return
 */
@ResponseBody
@RequestMapping(value = "verify/{name}",method = RequestMethod.GET)
public CommonResult verify(@PathVariable String name){
    CommonResult result = new CommonResult();
    Map<String,String> nameMap = new HashMap<>(2);
    nameMap.put("zhangsan","zhangsan");
    nameMap.put("lisi","lisi");
    String myName = nameMap.get(StringUtils.ios8859ToUtf8(name));
    if(null != myName){
	result.setMessage("该用户名已存在");
    }else{
	result.setSuccess(true);
    }
    return result;
}
```

## 内置正则表达式类型

```
var RULES = {
        email: "^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+",
        phone: "^1[3|4|5|7|8][0-9]\\d{8}$",
        //生日
        birthday: "^(19|20)\\d{2}-(1[0-2]|0?[1-9])-(0?[1-9]|[1-2][0-9]|3[0-1])$",
        //固话
        tel: "^0(10|2[0-5789]|\\d{3})-\\d{7,8}$",
        //身份证
        idcard: "((11|12|13|14|15|21|22|23|31|32|33|34|35|36|37|41|42|43|44|45|46|50|51|52|53|54|61|62|63|64|65|71|81|82|91)\\d{4})((((19|20)(([02468][048])|([13579][26]))0229))|((20[0-9][0-9])|(19[0-9][0-9]))((((0[1-9])|(1[0-2]))((0[1-9])|(1\\d)|(2[0-8])))|((((0[1,3-9])|(1[0-2]))(29|30))|(((0[13578])|(1[02]))31))))((\\d{3}(x|X))|(\\d{4}))",
        int: "^[0-9]\\d*$",
        //性别
        gender: "^['男'|'女']$",
        password: "^[\\w]{5,18}$",
        username: "^[a-zA-z]\\w{5,15}$",
        number: "^\\-?\\d+(\\.\\d+)?$",
        ip: "([0-9]{1,3}\\.{1}){3}[0-9]{1,3}",
        //中国的邮编
        zipcode: "^[1-9]\\d{5}$",
        //浮点数
        float: "^[+]?\\d+(\\.\\d+)?$",
        //验证前
        money: "(^[1-9]\\d{0,9}(\\.\\d{1,2})?$)",
        //验证中文
        chinese: "[\\u4E00-\\u9FA5\\uF900-\\uFA2D]",
        //验证url
        url: "^(http|https|ftp)\\:\\/\\/[a-z0-9\\-\\.]+\\.[a-z]{2,3}(:[a-z0-9]*)?\\/?([a-z0-9\\-\\._\\?\\,\\'\\/\\\\\\+&amp;%\\$#\\=~])*$"
    };
```
&nbsp;&nbsp;*1.内置正则的使用*
```
<!--使用 smartForm内置正则定义input type-->
<form action="">
    <!--smartForm自定义的username-->
    <label for="username">用户名：</label>
    <input type="username" id="username" name="username">

    <!--smartForm自定义的中文检测-->
    <label for="chinese">中文名：</label>
    <input type="chinese" id="chinese"  placeholder="请输入您的中文名">
    <!--html password-->
    <label for="password">密码：</label>
    <input type="password" id="password">
    <!--大祖国的邮编-->
    <label for="zipcode">邮编：</label>
    <input type="zipcode" id="zipcode" name="zipcode"/>
    <!--大祖国的固话-->
    <label for="tel">固话：</label>
    <input type="tel" id="tel" name="tel"/>
    <!--html5的phone-->
    <label for="phone">手机：</label>
    <input type="phone" id="phone" name="phone">
    <!--html5 email-->
    <label for="email">邮箱：</label>
    <input type="email" id="email" name="email"/>
    <!--大祖国的身份证-->
    <label for="idcard">身份证：</label>
    <input type="idcard" id="idcard" name="idcard"/>
    <!--用户自己输入性别，其实很少见-->
    <label for="gender">性别</label>
    <input type="gender" id="gender" name="gender" placeholder="请输入性别">
    <!--smartForm自定义金额验证-->
    <label for="money">价格：</label>
    <input type="money" id="money" placeholder="请填写正确的价格" name="price">
    <!--smartForm自定义float验证-->
    <label for="float">浮点数：</label>
    <input type="float" id="float">
    <!--smartForm自动义的ip验证-->
    <label for="ip"></label>
    <input type="ip" id="ip" name="ip">
    <!--html5 number-->
    <label for="number">数量：</label>
    <input type="number" id="number" name="number">
</form>
```
## SmartForm自定义属性
- data-placement属性用于加载到form标签上修改bootstrip tooltip的位置
- data-eq属性是SmartForm加载表单组件input 上用于验证输入字符否相同的，一般用于密码和确认密码

## SmartForm组件属性
```
 url: null,//ajax提交数据的url
 type: 'POST',//ajax提交数据的方式，不写时使用form 的method
 realTime: false,//是否开启实时验证
 sync: false,//是够支持同步,默认同步
 novalidate: true,//取消浏览器的默认验证
 placement: "right",//bootstrap tooltip的位置，默认是right
 dataType: 'json',//默认采用json对象，只支持json对象或者jsonString字符串
 toJsonString: true,//默认使用json字符串，false则采用From data提交
```
## SmartForm组件事件
1. validate 额外自定义事件，validate 没有任何参数，但是必须返回true或者false告诉smartForm是否验证已通过
2. beforeSend ajax发送数据前的回调事件，beforeSend 没有任何参数，使用请参考jquery ajax beforeSend
3. beforeSubmit ajax提交前的回调事件，当表单是普通表单时beforeSubmit的参数为 Object 如{name:'value',age:1}
当表单的enctype为multipart/form-data（ps:文件上传时）时beforeSubmit的参数为FormData
4. done ajax请求成功后的回调事件，done参数为后台返回的数据
5. fail ajax请求失败后的回调事件，fail没有参数
6. always ajax请求完成后的回调事件，无论失败或者成功都会执行，always没有参数

## SmartForm公共方法
1. destroy 销毁表单 $("#myform").smartForm("destroy");
1. clean  清空表单 $("#myform").smartForm("clean");