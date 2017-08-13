/**
 * 基于jquery的基本工具类
 * requires jquery 11+
 * @authors sunyu
 * @date    2015-10-25 22:30:44
 * @version 0.1
 */
//support AMD
;(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function ($) {
    'use strict';
    $.boco = {
        postJSON: function (url, data, successBk, options) {
            var opts = {
                type: "POST",
                url: url,
                contentType: "application/json; charset=UTF-8",
                data: JSON.stringify(data),
                dataType: "json",
                success: successBk,
                error: function () {

                }
            };
            if (options) {
                $.extend(opts, options);
            }
            return $.ajax(opts);
        },
        /**
         * judge whether it is today
         * @param timeSecond
         * @returns {boolean}
         */
        isToday: function (timeSecond) {
            if ($.type(timeSecond) === "number") {
                var inputNow = new Date(timeSecond);
                var nowYear = inputNow.getFullYear();
                var nowMonth = inputNow.getMonth();
                var nowDay = inputNow.getDate();

                var current = new Date();
                var currentYear = current.getFullYear();
                var currentMonth = current.getMonth();
                var currentDay = current.getDate();
                return nowYear === currentYear && nowMonth === currentMonth && nowDay === currentDay;
            } else {
                return false;
            }
        },
        /**
         * $.boco.getAge(new Date().getTime());
         * according to time stamp calculate age
         * @param millisecond
         * @returns {*}
         */
        getAge: function (millisecond) {
            if (millisecond === 0) {
                return 0;
            } else {
                var birthDate = new Date(millisecond);
                var nowDate = new Date();
                var nbDay = new Date(nowDate.getFullYear(), birthDate.getMonth(), birthDate.getDate());
                var age = nowDate.getFullYear() - birthDate.getFullYear();
                if (birthDate.getTime() > nowDate.getTime()) {
                    return '-';
                }
                var nowAge = (nbDay.getTime() <= nowDate.getTime() ? age : --age);
                return nowAge;
            }
        },
        /**
         * 小于10的在前面加0
         * @param timeNumber
         * @returns {string}
         */
        fixWithZero: function (timeNumber) {
            return (timeNumber < 10) ? '0' + timeNumber : timeNumber;
        },
        /**
         *
         * @param timeNumber
         * @param step
         */
        fixWidthStep: function (timeNumber, step) {
            var b = 0;
            timeNumber = this.parseInt(timeNumber, 10);
            step = this.parseInt(step, 10);
            var surplus = timeNumber % step;
            if (surplus === 0) {
                b = timeNumber;
            } else {
                b = 5 - surplus + timeNumber;
                b = (b > 55) ? 55 : b;
            }
            return this.fixWithZero(b);
        },
        /**
         * 产生随机hash
         * @returns {string}
         */
        randomHash: function () {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        },
        /**
         * 去除空格
         * @param text
         * @returns {XML|string}
         */
        trim: function (text) {
            return text.replace(/^\s+/, "").replace(/\s+$/, "");
        },
        //usage 0: $.boco.format("{0} {1}", "hello", "world");//hello world
        //usage 1: data =  {"id":1256,"uuid":"aaa"};
        //var c = $.boco.formatJson(data);
        //$.boco.format("<a href='#' onclick='{0}'>{1}</a>",'back1(\"'+c+'\")',me);
        //or  $.boco.format("<a href='#' onclick='test({0})'>me</a>",'\"'+c+'\"');
        //result:<a href='#' onclick='test("{\"id\":1256,\"uuid\":\"aaa\"}")'>me</a>
        //string as parameter:$.boco.format('<input value="Hello" type="button" onClick="gotoNode(\'{0}\')"/>​',result.name);
        //function test(time){var time0 = JSON.parse(time);console.log("UUID:"+time0.uuid);}
        format: function (source, params) {
            if (arguments.length === 1) {
                return function () {
                    var args = $.makeArray(arguments);
                    args.unshift(source);
                    return this.format.apply(this, args);
                };
            }
            if (arguments.length > 2 && params.constructor !== Array) {
                params = $.makeArray(arguments).slice(1);
            }
            if (params.constructor !== Array) {
                params = [params];
            }
            $.each(params, function (i, n) {
                source = source.replace(new RegExp("\\{" + i + "\\}", "g"), function () {
                    return n;
                });
            });
            return source;
        },
        /**
         * 判断空
         * $.boco.isEmpty('');//true
         * @param obj
         * @returns {boolean}
         */
        isEmpty: function (obj) {
            return obj === undefined || obj === null || new String(obj).trim() === '';
        },
        /**
         * 判断非空
         * @param obj
         * @returns {boolean}
         */
        isNotEmpty: function (obj) {
            return !this.isEmpty(obj);
        },
        /**
         * 获取真实长度
         * $.boco.realLength("dddd");//4
         * @param str
         * @returns {*}
         */
        realLength: function (str) {
            return this.isEmpty(str) ? 0 : str.replace(/[^\x00-\xff]/g, "**").length;
        },
        /**
         * 检测是否是函数
         * @param obj
         * @returns {boolean}
         */
        isFunction: function (obj) {
            return this.isEmpty(obj) ? false : typeof(obj) === 'function';
        },
        /**
         * 生成指定范围的随机数
         * $.boco.randomInt(1,100);
         * @param min 随机数最大范围
         * @param max 随机数最小范围
         * @returns {number}
         */
        randomInt: function (min, max) {
            return Math.floor(Math.random() * (max - min + 1) + min);
        },
        /**
         * 检测手机号
         * $.boco.isMobile('13121284654');//true
         * @param value
         * @returns {boolean}
         */
        isMobile: function (value) {
            var reg = /^((13[0-9])|(14[0-9])|(15[0-9])|(18[0-9])|(17[0-9]))\d{8}$/;
            return reg.test(value);
        },
        /**
         * 检测不是手机号
         * is not mobile
         * @param value
         * @returns {boolean}
         */
        isNotMobile: function (value) {
            return !this.isMobile(value);
        },
        /**
         * 验证中国居民身份证
         * $.boco.isID('53062199418120764');//true
         * @param value
         * @returns {boolean}
         */
        isID: function (value) {
            var pattern = /^((11|12|13|14|15|21|22|23|31|32|33|34|35|36|37|41|42|43|44|45|46|50|51|52|53|54|61|62|63|64|65|71|81|82|91)\d{4})((((19|20)(([02468][048])|([13579][26]))0229))|((20[0-9][0-9])|(19[0-9][0-9]))((((0[1-9])|(1[0-2]))((0[1-9])|(1\d)|(2[0-8])))|((((0[1,3-9])|(1[0-2]))(29|30))|(((0[13578])|(1[02]))31))))((\d{3}(x|X))|(\d{4}))$/;
            return pattern.test(value);
        },
        /**
         * 验证邮箱
         * $.boco.isEmail("aaaaaaa");//false
         * @param value
         * @returns {boolean}
         */
        isEmail: function (value) {
            var pattern = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
            return pattern.test(value);
        },
        /**
         * 检测整数
         * $.boco.isInteger('01');//false
         * @param value
         * @returns {boolean}
         */
        isInteger: function (value) {
            var pattern = /^[0-9]\d*$/;
            return pattern.test(value);
        },
        /**
         * 检测数字
         * @param obj
         * @returns {boolean}
         */
        isNumeric: function (obj) {
            return this.isEmpty(obj) ? false : typeof(obj) === 'number';
        },
        /**
         * 非负浮点数
         * $.boco.isNonNegativeFloat(0.9);
         * @param obj
         * @returns {boolean}
         */
        isNonNegativeFloat: function (obj) {
            var reg = /^\d+(\.\d+)?$/;
            return reg.test(obj);
        },
        // $.boco.formatNumber(1245555.22,3);//1,245,555.22
        formatNumber: function (num) {
            if (this.isNumeric(num)) {
                var parts = num.toString().split(".");
                parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                return parts.join(".");
            } else {
                return 'Is not a number';
            }
        },

        /**
         * var b = {"id":1,"uuid":"0d35"};
         * after format
         * $.boco.formatJson(b);result:{\"id\":1,\"uuid\":\"0d35\"}
         * @param json
         * @returns {string|void|XML|*}
         */
        formatJson: function (json) {
            var data = JSON.stringify(json);
            return data.replace(/\"/g, "\\\"");
        },
        /**
         * 过滤特殊字符
         * $.boco.filterCharacter('\n')
         * @param $str
         * @returns {string|XML|*}
         */
        filterChar: function ($str) {
            $str = $str.replace('"', '');
            $str = $str.replace("/r/n", '');
            $str = $str.replace("/t", '');
            $str = $str.replace("//", '');
            $str = $str.replace("/b", '');
            $str = $str.replace("\'", '')
            return $str;
        },
        /**
         * 根据时间戳计算属于第几周
         * usage:$.boco.getWeekNumber(new Date().getTime())
         * @param ms 时间戳
         * @returns {*[]}
         */
        getWeekNumber: function (ms) {
            // Copy date so don't modify original
            ms = new Date(ms);
            ms.setHours(0, 0, 1);
            // Set to nearest Thursday: current date + 4 - current day number
            // Make Sunday's day number 7
            ms.setDate(ms.getDate() + 4 - (ms.getDay() || 7));
            // Get first day of year
            var yearStart = new Date(ms.getFullYear(), 0, 1);
            // Calculate full weeks to nearest Thursday
            var weekNo = Math.ceil((((ms - yearStart) / 86400000) + 1) / 7)
            // Return array of year and week number
            var getFullYear = ms.getFullYear();
            var getWeekNo = weekNo;
            return [getFullYear, getWeekNo]
        },
        /**
         * 根据时间戳获取该时间戳的上一个月的第一天
         * @param ms 时间戳
         * @returns {number} 返回时间戳
         */
        getFirstDayOfLastMonth: function (ms) {
            var date = new Date(ms);
            date.setMonth(date.getMonth() - 1,1);
            date.setDate(1);
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            return date.getTime();
        },
        /**
         * 获取时间戳所属季度第一天
         * @param ms
         * @returns {number}
         */
        getFirstDayOfCurrentQuarter: function (ms) {
            var date = new Date(ms);
            var currentMonth = date.getMonth();
            if (currentMonth < 3) {
                date.setMonth(0);
            } else if (2 < currentMonth && currentMonth < 6) {
                date.setMonth(3);
            } else if (5 < currentMonth && currentMonth < 9) {
                date.setMonth(6);
            } else if (currentMonth > 8) {
                date.setMonth(9);
            }
            date.setDate(1);
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            return date.getTime();
        },
        /**
         * 获取时间戳所属年的第一天
         * @param ms
         * @returns {number}
         */
        getFirstDayOfCurrentYear:function(ms){
            var date = new Date(ms);
            date.setMonth(0);
            date.setDate(1);
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            return date.getTime();
        },
        /**
         * 获取时间戳所属月的第一天
         * $.boco.getFirstDayOfCurrentMonth(new Date().getTime());
         * @param ms
         * @returns {number}
         */
        getFirstDayOfCurrentMonth: function (ms) {
            var date = new Date(ms);
            date.setDate(1);
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            return date.getTime();
        },
        /**
         * 按中国习惯周一第一天
         * @param ms
         * @returns {number}
         */
        getFirstDayOfCurrentWeek:function(ms){
            var date = new Date(ms);
            date.setHours(0);
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            var nowDay = date.getDay(); // getDay 方法返回0 表示星期天
            nowDay = (nowDay === 0) ? 7 : nowDay;
            return date.getTime() - (nowDay-1)*864e5;
        },
        /**
         * 获取指定时间上一周的第一天
         * @param ms
         */
        getFistDayOfLastWeek:function(ms){
            return this.getFirstDayOfCurrentWeek(ms)-6048e5;
        },
        /**
         * 根据时间之间戳返回当周一周的时间戳
         * @param ms 时间戳
         * @returns {Array}
         */
        getWeekTimes: function (ms) {
            var arr = [];
            var date;
            if (ms) {
                date = new Date(ms);
            } else {
                date = new Date();
            }
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            var day = (date.getDay() || 7);//chinese
            date.setDate(date.getDate() - day + 1);
            for (var i = 0; i < 7; i++) {
                arr.push(date.getTime() + i * 86400000);
            }
            return arr;
        },
        /***
         * 将string转化成int,如果不合法则返回0
         * @param str
         * @param radix 进制
         * @returns {*}
         */
        parseInt: function (str, radix) {
            var reg = /^[1-9]\d*$/;
            if (reg.test(str)) {
                return parseInt(str, radix);
            } else {
                return 0;
            }
        },
        /**
         * 数据去重,对于json数据可以指定根据某一个属性去重
         * var arr = [1,2,2,3];
         * 对简单数组去重
         * $.boco.unique(arr);//[1,2,3]
         * var arr = [{"code":"001","name":"beijing"},{"code":"002","name":"beijing"}];
         * 根据name对arr中的数据去重
         *  $.boco.uique(arr,'name');//[{"code":"001","name":"beijing"}]
         * @param arr
         *            array data
         * @param attr
         *            property
         * @returns {Array}
         */
        unique: function (arr, attr) {
            var _arr = [];
            var table = {};
            if (this.isEmpty(attr)) {
                for (var i = 0; i < arr.length; i++) {
                    if (!table[arr[i]]) {
                        table[arr[i]] = arr[i];
                    }
                }
                for (var o in table) {
                    _arr.push(table[o]);
                }
            } else {
                for (var i = 0; i < arr.length; i++) {
                    if (!table[arr[i][attr]])
                        table[arr[i][attr]] = arr[i];
                }
                for (var o in table) {
                    _arr.push(table[o]);
                }
            }
            return _arr;
        },
        /**
         * obtain the second number according to the time stamp
         * @param time
         * @returns {number}
         */
        getTimeSecond: function (time) {
            var date = new Date(time);
            return parseInt(date.getHours() * 3600, 10) + parseInt(date.getMinutes() * 60, 10);
        },
        /**
         *
         * @param timeStamp
         * @param numDays
         *            days
         * @returns
         */
        dateAdd: function (date, numDays) {
            var today;
            if (date && this.isNumeric(numDays)) {
                today = new Date();
                today.setTime(date.getTime() + numDays * 864e5);
            }
            return today;
        },
        /**
         *
         * @param date
         * @returns
         */
        dateSlash: function (date) {
            var strDate;
            if (date) {
                var month = this.fixWithZero(date.getMonth() + 1);
                var day = this.fixWithZero(date.getDate());
                strDate = date.getFullYear() + "/" + month + "/" + day;
            } else {
                strDate = null;
            }
            return strDate;
        },

        /**
         * $.boco.eval('me');
         * Evaluates a given json string
         * @param str
         * @returns
         */
        eval: function (str) {
            return eval("(" + str + ")");
        },
        /**
         * Evals JSON in a way that is more secure.
         * @param str
         */
        secureEval: function (str) {
            var filtered =
                str
                    .replace(/\\["\\\/bfnrtu]/g, '@')
                    .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                    .replace(/(?:^|:|,)(?:\s*\[)+/g, '');
            if (/^[\],:{}\s]*$/.test(filtered)) {
                return eval('(' + str + ')');
            }
            throw new SyntaxError('Error parsing JSON, source is not valid.');
        },
        /**
         * convert long integer to ip
         * @param value
         * @returns {string|*}
         */
        longToIp: function (value) {
            var str;
            var tt = [];
            tt[0] = (value >>> 24) >>> 0;
            tt[1] = ((value << 8) >>> 24) >>> 0;
            tt[2] = (value << 16) >>> 24;
            tt[3] = (value << 24) >>> 24;
            str = String(tt[0]) + "." + String(tt[1]) + "." + String(tt[2]) + "." + String(tt[3]);
            return str;
        },
        /**
         * 判断是否是中文，全中文
         * @param str
         * @returns {boolean}
         */
        isChinesStr: function (str) {
            var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
            return reg.test(str);
        },
        /**
         * 判断是否包含中文
         * @param str
         * @returns {boolean}
         */
        isContainsChinese:function(str){
            var reg = /.*[\u4e00-\u9fa5]+.*$/;
            return reg.test(str);
        },
        escapeHTML: function (text) {
            if (typeof text === 'string') {
                return text
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#039;");
            }
            return text;
        },
        /**
         * 文件下载，属于get请求
         * 用例$.boco.downloadFile(url,{id:1,name:'zhangsan'});
         * @param url
         *          request url
         * @param params
         *          params like {id:1,name:'zhangsan'}
         */
        downloadFile: function (url, params) {
            window.location.href = this.castToGetUri(url,params);
        },
        /**
         * 根据参数对象将拼接成get形式的url
         * @param url
         * @param params
         * @returns {string}
         */
        castToGetUri: function (url,params) {
            if (params instanceof Object && !(params instanceof Array)) {
                var pm = params || {};
                var arr = [];
                arr.push(url);
                var j = 0;
                for (var i in pm) {
                    if (j === 0) {
                        arr.push("?");
                        arr.push(i + "=" + encodeURI(pm[i]) );
                    } else {
                        arr.push("&" + i + "=" + encodeURI(pm[i]));
                    }
                    j++;
                }
               return arr.join("");
            } else {
                throw "param is not plain Object"
            }
        },
        /**
         * 根据get请求连接获取参数
         * @param urlStr 如果该参数为空则默认用location.search
         * @returns {{}}
         */
        getParameters:function(urlStr){
            var url =  this.isEmpty(urlStr)?location.search:urlStr; //获取url中"?"符后的字串
            var theRequest = {};
            if (url.indexOf("?") != -1) {
                var str = url.substr(1);
                var strS = str.split("&");
                for(var i = 0; i < strS.length; i ++) {
                    theRequest[strS[i].split("=")[0]]=decodeURI(strS[i].split("=")[1]);
                }
            }
            return theRequest;
        },
        /**
         * 对象排序
         * usage:
         * var people = {
         *
         * }
         * people.sort(sortObjectsByParam("lastname"));
         * @param param
         * @returns {Function}
         */
        sortObjectsByParam: function (param) {
            return function (a, b) {
                if (a[param] == b[param]) {
                    return 0;
                }
                if (a[param] > b[param]) {
                    return 1;
                } else {
                    return -1;
                }
            }
        },
        /**
         * 使用post方式
         * $.boco.ajaxDownload(url,params);
         * @param url
         * @param params
         *  data like {id:1,name:'zhangsan'}
         */
        ajaxDownload: function (url, params) {
            var $iframe, iframeDoc, iframeHtml;
            if (($iframe = $('#download_iframe')).length === 0) {
                $iframe = $("<iframe id='download_iframe'" +
                    " style='display: none' src='about:blank'></iframe>"
                ).appendTo("body");
            }
            iframeDoc = $iframe[0].contentWindow || $iframe[0].contentDocument;
            if (iframeDoc.document) {
                iframeDoc = iframeDoc.document;
            }
            iframeHtml = "<html><head></head><body><form method='POST' action='" + url + "'>"
            Object.keys(params).forEach(function (key) {
                iframeHtml += "<input type='hidden' name='" + key + "' value='" + params[key] + "'>";
            });
            iframeHtml += "</form></body></html>";
            iframeDoc.open();
            iframeDoc.write(iframeHtml);
            $(iframeDoc).find('form').submit();
        },
        /**
         * 使用post方式
         * $.boco.download(url,params);
         * @param url 请求链接
         * @param params 参数，例如{id:1,name:'zhangsan'}
         *
         */
        download: function (url, params) {
            if (params instanceof Object && !(params instanceof Array)) {
                var downloadFrame = document.getElementById('ownloadFrame');
                if (downloadFrame === null) {
                    downloadFrame = document.createElement('iframe');
                    downloadFrame.src = "about:blank";
                    downloadFrame.style.display = 'none';
                    downloadFrame.id = "downloadFrame";
                    downloadFrame.name = "downloadFrame";
                    document.body.appendChild(downloadFrame);
                }
                var frameDocument = downloadFrame.contentWindow.document;
                frameDocument.open();
                frameDocument.close();
                var downloadForm = frameDocument.createElement("form");
                downloadForm.setAttribute("target", "downloadFrame");
                downloadForm.setAttribute("method", "POST");
                downloadForm.setAttribute("action", url);
                for (var key in params) {
                    var hiddenField = frameDocument.createElement("input");
                    hiddenField.setAttribute('type', "hidden");
                    hiddenField.setAttribute('name', key);
                    hiddenField.setAttribute('value', params[key]);
                    downloadForm.appendChild(hiddenField);
                }
                downloadFrame.appendChild(downloadForm);
                downloadForm.submit();
            } else {
                throw "param is not plain Object"
            }
        },
        /**
         * 对非动态有用
         * select option by value
         * @param selectId
         * @param value
         */
        setSelectByValue: function (selectId, value) {
            var select = document.getElementById(selectId);
            var opt;
            for (var i = 0, len = select.options.length; i < len; i++) {
                opt = select.options[i];
                if (opt.value == value) {
                    opt.selected = true;
                    break;
                }
            }
        },
        /**
         * get checkbox checked values via
         * usage:$.boco.getCheckedValues("org","#up-org");
         * or $.boco.getCheckedValues("org")
         * @param checkBoxName checkbox name
         * @param  containerId container id
         * @returns {Array}
         */
        getCheckedValues: function (checkBoxName, containerId) {
            var valArr = [];
            if (containerId) {
                $(containerId + " input[name='" + checkBoxName + "']:checked").each(function () {
                    var val = $(this).val();
                    if ($.boco.isNotEmpty(val)) {
                        valArr.push(val)
                    }
                });
            } else {
                $("input[name='" + checkBoxName + "']:checked").each(function () {
                    var val = $(this).val();
                    if ($.boco.isNotEmpty(val)) {
                        valArr.push(val)
                    }
                });
            }
            return valArr;
        },
        /**
         * 通过值设置checkbox选中
         * set checkbox checked by values
         * NOTE:ever item in Array must be a string
         * @param selectId checkbox所属容器的编号
         * @param checkBoxName checkbox的名称
         * @param valuesArr
         */
        setCheckedByValues: function (selectId, checkBoxName, valuesArr) {
            $("#" + selectId).find(':checkbox[name="' + checkBoxName + '"]').each(function () {
                $(this).prop("checked", ($.inArray($(this).val(), valuesArr) != -1));
            });
        },
        /**
         * 通过select 的text选中select
         * @param selectId select的id
         * @param text 文本值
         */
        setSelectByText: function (selectId, text) {
            var select = document.getElementById(selectId);
            var opt;
            var len = select.options.length;
            for (var i = 0; i < len; i++) {
                opt = select.options[i];
                if (opt.text == text) {
                    opt.selected = true;
                    break;
                }
            }
        },
        /**
         * 根据表单编号清空表单所有的字段值
         * usage:$.boco.clearForm("#add-form");
         * @param ele 表单id
         */
        clearForm: function (ele) {
            $(ele).find(":input").not(":button,:submit,:reset").val("")
                .removeAttr("checked").removeAttr("selected")
        },
        /**
         * 移除单引号
         * @param str
         * @returns {*}
         */
        removeSingleQuotes: function (str) {
            if (this.isNotEmpty(str)) {
                return str.replace("'", "");
            } else {
                return "";
            }
        },
        /**
         * check username
         * @param str
         * @returns {boolean}
         */
        isUserName: function (str) {
            var reg = /^[a-zA-z]\w{5,15}$/;
            return reg.test(str);
        },
        /**
         * check password
         * @param str
         * @returns {boolean}
         */
        isPassWord: function (str) {
            var reg = /^[\w]{5,18}$/;
            return reg.test(str);
        },
        /**
         * 除法统一处理,分母数有误
         * @param denominator
         *          分母
         * @param numerator
         *          分子
         * @param msg
         *          提示信息
         */
        division:function(denominator,numerator,msg){
            if(numerator === 0){
                if(this.isEmpty(msg)){
                    return '数据错误';
                }else{
                    return msg;
                }
            }else{
                return denominator/numerator;
            }
        },
        serialize:function(ele){
            var dataArray = $(ele).serializeArray();
            var result = {};
            $(dataArray).each(function () {
                if (result[this.name]) {
                    result[this.name].push(this.value);
                } else {
                    var element = $(ele).find("[name='" + this.name + "']")[0];
                    var type = ( element.type || element.nodeName ).toLowerCase();
                    result[this.name] = (/^(select-multiple|checkbox)$/i).test(type) ? [this.value] : this.value;
                }
            });
            return result;
        }
    };
}));