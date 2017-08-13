/*******************************************************************************
 * jquery-smartForm v0.1 requires jQuery 1.11+ bootstrap 3.0+
 * @author sunyu
 * @date 2016-12-22 23:16:52
 * @version 0.1
 ******************************************************************************/
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
    var FormData = window.FormData;
    var SmartForm = function (element, options) {
        this.options = options;
        this.$el = $(element);
        this.id = this.$el.attr("id");
        this.disabled = false;
        this.init();
    };
    SmartForm.VALID_SELECTOR = "input:not([type='submit'], [type='reset']),textarea,select";
    SmartForm.DEFAULTS = {
        //default settings
        url: null,
        type: 'post',
        realTime: false,//是否开启实时验证
        isPassed: true,
        sync: false,//是够支持同步
        submitBtn:null,//指定了提交按钮则跳过原有的submit
        novalidate: true,//取消浏览器的默认验证
        placement: "right",//bootstrap tooltip placement,default is write
        dataType: 'json',//默认采用json对象，只支持json对象或者jsonString字符串
        toJsonString: true,
        beforeSubmit: function () {
        },
        beforeSend: function () {
        },
        done: function () {
        },
        fail: function () {
        },
        always: function () {
        },
        validate: function () {
            return true;
        }
    };
    //validate rules
    var RULES = {
        email: "^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+",
        phone: "^1[3|4|5|7|8][0-9]\\d{8}$",
        birthday: "^(19|20)\\d{2}-(1[0-2]|0?[1-9])-(0?[1-9]|[1-2][0-9]|3[0-1])$",
        tel: "^0(10|2[0-5789]|\\d{3})-\\d{7,8}$",
        idcard: "((11|12|13|14|15|21|22|23|31|32|33|34|35|36|37|41|42|43|44|45|46|50|51|52|53|54|61|62|63|64|65|71|81|82|91)\\d{4})((((19|20)(([02468][048])|([13579][26]))0229))|((20[0-9][0-9])|(19[0-9][0-9]))((((0[1-9])|(1[0-2]))((0[1-9])|(1\\d)|(2[0-8])))|((((0[1,3-9])|(1[0-2]))(29|30))|(((0[13578])|(1[02]))31))))((\\d{3}(x|X))|(\\d{4}))",
        int: "^[0-9]\\d*$",
        gender: "^['男'|'女']$",
        password: "^[\\w]{5,18}$",
        username: "^[a-zA-z]\\w{5,15}$",
        number: "^\\-?\\d+(\\.\\d+)?$",
        ip: "([0-9]{1,3}\\.{1}){3}[0-9]{1,3}",
        zipcode: "^[1-9]\\d{5}$",
        float: "^[+]?\\d+(\\.\\d+)?$",
        money: "(^[1-9]\\d{0,9}(\\.\\d{1,2})?$)",
        chinese: "[\\u4E00-\\u9FA5\\uF900-\\uFA2D]",
        url: "^(http|https|ftp)\\:\\/\\/[a-z0-9\\-\\.]+\\.[a-z]{2,3}(:[a-z0-9]*)?\\/?([a-z0-9\\-\\._\\?\\,\\'\\/\\\\\\+&amp;%\\$#\\=~])*$",
        domain:"^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](?:\\.[a-zA-Z]{2,})+$"
    };
    SmartForm.LOCALES = [];
    SmartForm.LOCALES['zh-CN'] = SmartForm.LOCALES['cn'] = {};
    $.extend(SmartForm.DEFAULTS, SmartForm.LOCALES['zh-CN']);

    // private function definition
    SmartForm.prototype.init = function () {
        if (this.options.novalidate) {
            this.$el.attr("novalidate", "novalidate");
        }
        this.options.isPassed = true;
        if (!this.options.url) {
            //use the current page if not set
            this.options.url = this.$el.prop('action');
        }
        var pageMethod = this.$el.attr('method') || this.$el.prop('method');
        if (!this.options.type) {
            this.options.type = pageMethod;
        }
        var placement = this.$el.data('placement');
        if (placement) {
            this.options.placement = placement;
        }
        this.initValid();
        if(this.options.submitBtn){
            $(this.options.submitBtn).off("click").on("click", $.proxy(this.submit, this));
        }else{
            this.$el.off("submit").on("submit", $.proxy(this.submit, this));
        }
    };
    //init validate,while realTime property value is true
    SmartForm.prototype.initValid = function () {
        var me = this;
        if (this.options.realTime) {
            this.$el.find(SmartForm.VALID_SELECTOR).each(function () {
                var ele = $(this);
                if (ele) {
                    ele.blur(function () {
                        me.validOne(ele);
                    });
                }
            });
        }
    };
    /**
     * form submit event
     * @param {Event} e
     */
    SmartForm.prototype.submit = function (e) {
        var me = this;
        e.preventDefault();
        var flag = this.validAll();
        var customValidateFlag = me.options.validate();
        if (flag && customValidateFlag) {
            var ajaxOptions;
            if (this.disabled) {
                e.preventDefault();
                return;
            }
            this.disabled = true;
            if (!this.options.sync) {
                if(this.options.url){
                    ajaxOptions = $.extend({}, this.options, {
                        type: me.options.type,
                        beforeSend: $.proxy(me.beforeSend, this)
                    });
                    if (FormData && this.$el.attr("enctype") === "multipart/form-data") {
                        //handle file upload
                        var formData = new FormData(this.$el[0]);
                        this.options.beforeSubmit(formData);
                        ajaxOptions.data = formData;
                        ajaxOptions.processData = false;
                        ajaxOptions.contentType = false;
                    } else {
                        var data = this.serialize();
                        this.options.beforeSubmit(data);
                        if (this.options.toJsonString) {
                            ajaxOptions.data = JSON.stringify(data);
                            //ajaxOptions.dataType = "json";
                            ajaxOptions.contentType = "application/json";
                        } else {
                            ajaxOptions.data = data;
                            ajaxOptions.dataType = "json";
                        }
                    }
                    $.ajax(ajaxOptions).done(function (result) {
                        me.success(result);
                    }).fail(function () {
                        me.error();
                    }).always(function () {
                        me.complete();
                    });
                }else{
                    throw new Error("Can't find submit url.");
                }
            } else {
                this.$el.off("submit").submit();
            }
        }
    };
    /**
     * custom serialize from data
     * @returns {{}}
     */
    SmartForm.prototype.serialize = function () {
        var me = this;
        var dataArray = me.$el.serializeArray();
        var result = {};
        $(dataArray).each(function () {
            if (result[this.name]) {
                result[this.name].push(this.value);
            } else {
                var element = me.$el.find("[name='" + this.name + "']")[0];
                var type = ( element.type || element.nodeName ).toLowerCase();
                result[this.name] = (/^(select-multiple|checkbox)$/i).test(type) ? [this.value] : this.value;
            }
        });
        return result;
    };
    /**
     * invoked by jquery ajax beforeSend
     * @param jqXHR
     * @param textStatus
     */
    SmartForm.prototype.beforeSend = function (jqXHR, textStatus) {
        this.$el.find(':submit').prop('disabled', true);
        var options = this.options;
        if ($.isFunction(options.beforeSend)) {
            options.beforeSend(jqXHR, textStatus);
        }
    };
    /**
     * invoked by jquery ajax done
     * @param {Object} data
     */
    SmartForm.prototype.success = function (data) {
        var options = this.options;
        if ($.isFunction(options.done)) {
            options.done(data);
        }
    };
    /**
     * invoked when the ajax fail
     */
    SmartForm.prototype.error = function () {
        var options = this.options;
        if ($.isFunction(options.fail)) {
            options.fail();
        }
    };
    /**
     * invoked
     */
    SmartForm.prototype.complete = function () {
        var options = this.options;
        this.disabled = false;
        this.$el.find(':submit').prop('disabled', false);
        if ($.isFunction(options.always)) {
            options.always();
        }
    };
    /**
     * get regex expressions by html5 type or custom type
     * @param {String} type
     * @returns {*}
     */
    SmartForm.prototype.getRule = function (type) {
        switch (type) {
            case "int":
                return RULES.int;
            case "number":
                return RULES.number;
            case "email":
                return RULES.email;
            case "phone":
                return RULES.phone;
            case "username":
                return RULES.username;
            case "password":
                return RULES.password;
            case "idcard":
                return RULES.idcard;
            case "ip":
                return RULES.int;
            case "zipcode":
                return RULES.zipcode;
            case "url":
                return RULES.url;
            case "chinese":
                return RULES.chinese;
            case "money":
                return RULES.money;
            case "float":
                return RULES.float;
            case "gender":
                return RULES.gender;
            case "domain":
                return RULES.domain;
            default:
                return undefined;
                break;
        }
    };
    /**
     * this function is invoked when users click the "submit" button
     * @returns {boolean}
     */
    SmartForm.prototype.validAll = function () {
        var flag = true;
        var me = this;
        this.$el.find(SmartForm.VALID_SELECTOR).each(function () {
            var ele = $(this);
            if (ele) {
                flag = me.validOne(ele);
                if (!flag) {
                    return false;
                }
            }
        });
        return flag;
    };
    /**
     * valid one
     * @param ele
     *          element id
     * @returns {boolean}
     */
    SmartForm.prototype.validOne = function (ele) {
        var flag = true;
        var errors = [];//error container
        var me = this;
        var type = me.html5Attr(ele, "type");
        var msg = me.html5Attr(ele, "title") || '格式不正确';//get error msg
        var required = me.html5Attr(ele, "required") || undefined;
        var $target = $(ele);
        var value = $target.val();

        var tagName = $target[0].tagName.toLowerCase();
        //radio
        if (tagName == "input" && type && type.toLowerCase() === "radio") {
            var errors = [];
            var checked = me.$el.find("input[type=" + type.toLowerCase() + "]:checked");
            if (required) {
                if (checked.length == 0) {
                  errors.push(msg);
                }
            }
            return me.handleError(errors, ele);
        }
        //checkbox
        if(tagName == "input" && type && type.toLowerCase() === "checkbox"){
            var errors = [];
            var maxCheck = parseInt($target.data("maxlength"));
            var minCheck = parseInt($target.data("minlength"));
            var checked = me.$el.find("input[type=" + type.toLowerCase() + "]:checked");
            var checkedLength = checked.length;
            if (required) {
                if (checkedLength == 0) {
                    errors.push(msg);
                }
            }
            if(minCheck&&!errors.length&&checked<checkedLength){
                errors.push("至少要选中 "+minCheck+" 项！")
            }
            if(maxCheck&&!errors.length&&checked<checkedLength){
                errors.push("最多选中 "+maxCheck+" 项！")
            }
            return me.handleError(errors, ele);
        }

        var pattern = this.html5Attr(ele, "pattern") || (function () {
                //like pipe,validate a input could fill in phone or email
                return type && $.map(type.split("|"), function (typeSplit) {
                        var matchRegex = me.getRule(typeSplit);
                        if (matchRegex) return matchRegex;
                    }).join("|");
            })();
        //validate input
        if (tagName == "input") {
            var eq = $target.data("eq");
            var $ajaxVerify;
            if (required) {
                if ($.trim(value) == "") {
                    errors.push(msg);
                }
            }
            if (!errors.length && pattern) {
                var reg = new RegExp(pattern);
                if (!reg.test(value)) {
                    errors.push(msg);
                }
            } else if (!errors.length && eq) {
                if (value !== $(eq).val()) {
                    errors.push(msg);
                }
            } else if (!errors.length && value && $target.data('url')) {
                var name = $target.attr("name");
                var msgId = me.id + "-" + name + "-msg";
                var valueId = me.id + "-" + name + "-val";
                var successId = me.id + "-" + value + "success";

                var successFlag = sessionStorage.getItem(successId) === "true";
                var storageValue = sessionStorage.getItem(valueId);
                if (!successFlag && (storageValue != value)) {
                    $ajaxVerify = $.get($target.data('url') + "/" + encodeURI(value)).done(function (result) {
                        if (result.success) {
                            sessionStorage.setItem(valueId, undefined);
                            sessionStorage.setItem(msgId, undefined);
                            sessionStorage.setItem(successId, true);
                        } else {
                            errors.push(result.message);
                            sessionStorage.setItem(valueId, value);
                            sessionStorage.setItem(msgId, result.message);
                            sessionStorage.setItem(successId, false);
                        }
                    }).fail(function () {
                        errors.push("服务器出错误！");
                        sessionStorage.setItem(valueId, value);
                        sessionStorage.setItem(msgId, "服务器出错误！");
                        sessionStorage.setItem(successId, false);
                    });
                } else {
                    if (!successFlag) {
                        errors.push(sessionStorage.getItem(valueId))
                    }
                }
            }
            if ($ajaxVerify) {
                $ajaxVerify.done(function () {
                    return me.handleError(errors, ele);
                })
            } else {
                if (!errors.length) {
                    errors.push.apply(errors, me.isOverflow(ele));
                }
                return me.handleError(errors, ele);
            }
        } else if (tagName == "textarea") {
            if (required) {
                errors.push(msg);
            } else if (!errors.length) {
                errors.push.apply(errors, me.isOverflow(ele));
            }
            return me.handleError(errors, ele);
        } else if (tagName == "select") {
            if (required) {
                var $trimmedValue = $.trim(value);
                if ($trimmedValue == 0 || $trimmedValue == "" || $trimmedValue == undefined) {
                    errors.push(msg);
                }
            }
            return me.handleError(errors, ele);
        }
        return flag;
    };
    /**
     * handle validate errors
     * @param {Array} errors
     * @param ele
     * @returns {boolean}
     */
    SmartForm.prototype.handleError = function (errors, ele) {
        if (errors.length) {
            this.showTip(ele,errors[0]);
            $(ele).focusin();
            return false;
        } else {
            this.destroyTip(ele);
            return true;
        }
    };
    /**
     *
     * @param {Element} ele
     * @returns {Array}
     */
    SmartForm.prototype.isOverflow = function (ele) {
        var errors = [];
        var $ele = $(ele);
        //number limit
        var attrMin = $ele.attr("min");
        var attrMax = $ele.attr("max");

        var attrStep;
        //length limit
        var attrDataMin;
        var attrDataMax;
        var value = $ele.val();

        if (!attrMin && !attrMax) {
            attrDataMin = $ele.data("minlength");
            attrDataMax = $ele.data("maxlength");
            if (attrDataMin && value.length < attrDataMin) {
                errors.push("至少输入" + attrDataMin + "个字符")
            } else if (attrDataMax && value.length > attrDataMax) {
                errors.push("最多输入" + attrDataMax + "个字符");
            }
        } else {
            //number limit
            value = Number(value);
            attrStep = Number($ele.attr("step")) || 1;
            if (attrMin && value < attrMin) {
                errors.push("值必须大于或等于" + attrMin);
            } else if (attrMax && value > attrMax) {
                errors.push("值必须小于或等于" + attrMax);
            } else if (attrStep && !/^\d+(\.0+)?$/.test((Math.abs((value - attrMin || 0)) / attrStep).toFixed(10))) {
                errors.push("值无效")
            }
        }
        return errors;
    };
    /**
     *
     * @param ele
     *          element id
     * @param attr
     * @returns {*|jQuery}
     */
    SmartForm.prototype.html5Attr = function (ele, attr) {
        return $(ele).attr(attr);
    };
    /**
     *
     * @param ele
     *          element id
     * @param msg
     */
    SmartForm.prototype.showTip = function (ele,msg) {
        var me = this;
        var opts = {
            trigger: 'manual',
            placement:me.options.placement
        };
        if(msg){
            opts.title = msg;
        }
        $(ele).tooltip(opts).tooltip("show");
    };
    SmartForm.prototype.destroyTip = function (ele) {
        $(ele).tooltip('destroy');
    };
    // public function definition
    SmartForm.prototype.destroy = function () {
        this.$el.removeData('smartForm');
    };
    //clean form
    SmartForm.prototype.clean = function () {
        this.$el.find(":input").not(":button,:submit,:reset").val("")
            .removeAttr("checked").removeAttr("selected")
    };
    // public definition
    var methods = ['destroy', 'clean'];
    $.fn.smartForm = function (option) {
        var value;
        var args = Array.prototype.slice.call(arguments, 1);
        this.each(function () {
            var $this = $(this);
            var data = $this.data('smartForm');
            var options = $.extend({}, SmartForm.DEFAULTS, $this.data(),
                typeof option === 'object' && option);
            if (typeof option === 'string') {
                if ($.inArray(option, methods) < 0) {
                    throw new Error('Method ' + option
                        + ' does not exist on jQuery-smartForm');
                }
                if (!data) {
                    return;
                }
                value = data[option].apply(data, args);
            }
            if (!data) {
                $this.data('smartForm', (new SmartForm(this, options)));
            }
        });
        return typeof value === 'undefined' ? this : value;
    };
    $.fn.smartForm.Constructor = SmartForm;
    $.fn.smartForm.defaults = SmartForm.DEFAULTS;
    $.fn.smartForm.methods = methods;
    $.fn.tip = function(options){
        var defaultOpts = {
            trigger: 'manual',
            placement: 'right'
        };
        var opt = $.extend({},defaultOpts);
        if(typeof options == 'string'){
            opt.title = options;
        }else{
            $.extend(opt, options);
        }
        $('.tooltip-inner').css('background-color', 'red');
        $(this).data(opt).tooltip("show");
    };
    $(function () {
        $('[data-toggle="smartForm"]').smartForm();
    });
}));
