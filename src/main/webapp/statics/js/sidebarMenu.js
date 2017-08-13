/*******************************************************************************
 * jquery-sidebarMenu v0.1 requires jQuery 1.11+
 * @author yu
 * @date 2016-12-18 13:26:03
 * @version 0.1
 ******************************************************************************/
//support AMD
;(function(factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define([ 'jquery' ], factory);
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function($) {
    'use strict';
    var SidebarMenu = function(element, options) {
        this.options = options;
        this.$el = $(element);
        this.init();
    };
    SidebarMenu.DEFAULTS = {
        url:'',//remote request
        method:'POST',//default post
        params:{},//remote request params
        data:null,
        done:function(){

        },
        error:function(){

        }
        //default settings
    };
    SidebarMenu.LOCALES = [];
    SidebarMenu.LOCALES['zh-CN'] = SidebarMenu.LOCALES['cn'] = {};
    $.extend(SidebarMenu.DEFAULTS,SidebarMenu.LOCALES['zh-CN']);

    // private function definition
    SidebarMenu.prototype.init = function() {
        var $me = this;
        this.initDom();//初始化dom
        if(this.options.data) {
            this.createByLocalData(this.options.data);
            this.menuEvent();
        }else{
            if (!this.options.url) return;
            $.ajax({
                url:this.options.url,
                type:this.options.method,
                data:this.options.params,
                beforeSend: function () {

                },
                success:function(data){
                    $me.createMenusByAjax(data);
                    $me.menuEvent();
                    $me.options.done();
                },
                error:function(){
                    $me.options.error();
                }
            })
        }
    };
    /**
     * 初始化dom
     */
    SidebarMenu.prototype.initDom = function(){
        $("body").removeClass("hold-transition")
        $("#content-wrapper").find('.mainContent').height($(window).height() - 135);
        $(window).resize(function (e) {
            $("#content-wrapper").find('.mainContent').height($(window).height() - 135);
        });
        $(".sidebar-toggle").click(function () {
            if (!$("body").hasClass("sidebar-collapse")) {
                $("body").addClass("sidebar-collapse");
            } else {
                $("body").removeClass("sidebar-collapse");
            }
        });
        $(window).load(function () {
            window.setTimeout(function () {
                $('#ajax-loader').fadeOut();
            }, 300);
        });
    };
    /**
     * 数据分组
     * @param data
     *          源数据
     * @param action
     *          分组策略
     * @returns {Array}
     */
    SidebarMenu.prototype.jsonWhere = function(data,action){
        var reVal = new Array();
        $(data).each(function (i, v) {
            if (action(v)) {
                reVal.push(v);
            }
        });
        return reVal;
    };
    SidebarMenu.prototype.isEmpty = function(obj){
        return obj === undefined || obj === null || new String(obj).trim() === '';
    };
    /**
     * 使用本地数据来创建菜单
     * @param data
     */
    SidebarMenu.prototype.createByLocalData = function(data){
        var len = data.length;
        var menuHtml = "";
        for(var i =0;i<len;i++){
            var row = data[i];
            if(i==0){//一级菜单
                menuHtml += '<li class="treeview active">';
            }else{
                menuHtml += '<li class="treeview">';
            }
            menuHtml += '<a href="#">';
            menuHtml += '<i class="' + row.icon + '"></i><span>' + row.name + '</span><i class="fa fa-angle-left pull-right"></i>';
            menuHtml += '</a>';
            var son = row.children;

            if((!this.isEmpty(son))&&son.length>0){//如果二级菜单内容不为空
                menuHtml += '<ul class="treeview-menu">';//二级菜单
                for(var j = 0;j<son.length;j++){
                    var sonData = son[j];
                    menuHtml += '<li>';//二级菜单列
                    var grandson = sonData.children;
                    if((!this.isEmpty(grandson))&&grandson.length>0){ //如果三级菜单内容不为空
                        menuHtml += '<a href="#"><i class="' + sonData.icon + '"></i>' + sonData.name + '';
                        menuHtml += '<i class="fa fa-angle-left pull-right"></i></a>';
                        menuHtml += '<ul class="treeview-menu">';//三级菜单
                        for(var n =0;n<grandson.length;n++){//循环生成三级菜单
                            var grandsonData = grandson[n];
                            menuHtml += '<li>' +
                                '<a class="menuItem" data-desc="'+row.name+'&nbsp;/&nbsp;'+sonData.name+'&nbsp;/&nbsp;'+grandsonData.name+'" data-id="' + grandsonData.moduleId + '" href="' + grandsonData.url + '">' +
                                '<i class="' + grandsonData.icon + '"></i>' + grandsonData.name + '' +
                                '</a></li>';
                        }
                        menuHtml += '</ul>';
                    }else{//没有三级菜单内容时直接生成二级菜单项
                        menuHtml += '<a class="menuItem" data-desc="'+row.name+'&nbsp;/&nbsp;'+sonData.name+'" data-id="' + sonData.moduleId + '" href="' + sonData.url + '">' +
                            '<i class="' + sonData.icon + '"></i>' + sonData.name + '</a>';
                    }
                    menuHtml += '</li>';
                }
                menuHtml += '</ul>';
            }
            menuHtml += '</li>'
        }
        $("#sidebar-menu").append(menuHtml);
    };
    //通过ajax获取菜单
    SidebarMenu.prototype.createMenusByAjax = function(data) {
        var $me = this;
        var menuHtml = "";
        $.each(data, function (i) {
            var row = data[i];
            if (row.parentId == "0") {
                if (i == 0) {
                    menuHtml += '<li class="treeview active">';
                } else {
                    menuHtml += '<li class="treeview">';
                }
                menuHtml += '<a href="#">'
                menuHtml += '<i class="' + row.icon + '"></i><span>' + row.name + '</span><i class="fa fa-angle-left pull-right"></i>'
                menuHtml += '</a>'
                var son = $me.jsonWhere(data, function (v) { return v.parentId == row.moduleId });
                if (son.length > 0) {
                    menuHtml += '<ul class="treeview-menu">';
                    $.each(son, function (i) {
                        var sonData = son[i];
                        var grandson = $me.jsonWhere(data, function (v) { return v.parentId == sonData.moduleId });
                        menuHtml += '<li>';
                        if (grandson.length > 0) {
                            menuHtml += '<a href="#"><i class="' + sonData.icon + '"></i>' + sonData.name + '';
                            menuHtml += '<i class="fa fa-angle-left pull-right"></i></a>';
                            menuHtml += '<ul class="treeview-menu">';
                            $.each(grandson, function (i) {
                                var grandsonData = grandson[i];
                                menuHtml += '<li>' +
                                    '<a class="menuItem" data-id="' + grandsonData.moduleId + '" href="' + grandsonData.url + '">' +
                                    '<i class="' + grandsonData.icon + '"></i>' + grandsonData.name + '' +
                                    '</a></li>';
                            });
                            menuHtml += '</ul>';

                        } else {
                            menuHtml += '<a class="menuItem" data-id="' + sonData.moduleId + '" href="' + sonData.url + '"><i class="' + sonData.icon + '"></i>' + sonData.name + '</a>';
                        }
                        menuHtml += '</li>';
                    });
                    menuHtml += '</ul>';
                }
                menuHtml += '</li>'
            }
        });
        $("#sidebar-menu").append(menuHtml);
    };
    /**
     * 菜单事件
     */
    SidebarMenu.prototype.menuEvent = function() {
        $("#sidebar-menu li a").click(function () {
            var d = $(this), e = d.next();
            if (e.is(".treeview-menu") && e.is(":visible")) {
                e.slideUp(500, function () {
                    e.removeClass("menu-open")
                }),
                    e.parent("li").removeClass("active")
            } else if (e.is(".treeview-menu") && !e.is(":visible")) {
                var f = d.parents("ul").first(),
                    g = f.find("ul:visible").slideUp(500);
                g.removeClass("menu-open");
                var h = d.parent("li");
                e.slideDown(500, function () {
                    e.addClass("menu-open"),
                        f.find("li.active").removeClass("active"),
                        h.addClass("active");

                    var _height1 = $(window).height() - $("#sidebar-menu >li.active").position().top - 41;
                    var _height2 = $("#sidebar-menu li > ul.menu-open").height() + 10
                    if (_height2 > _height1) {
                        $("#sidebar-menu >li > ul.menu-open").css({
                            overflow: "auto",
                            height: _height1
                        })
                    }
                });
            }
            e.is(".treeview-menu");
        });
    };

    // public function definition
    SidebarMenu.prototype.destroy = function() {
        this.$el.removeData('sidebarMenu');
    };
    // public definition
    var methods = ['destroy'];
    $.fn.sidebarMenu = function(option) {
        var value;
        var args = Array.prototype.slice.call(arguments, 1);
        this.each(function() {
            var $this = $(this);
            var data = $this.data('sidebarMenu');
            var options = $.extend({},SidebarMenu.DEFAULTS, $this.data(),
                typeof option === 'object' && option);
            if (typeof option === 'string') {
                if ($.inArray(option, methods) < 0) {
                    throw new Error('Method ' + option
                        + ' does not exist on jQuery-sidebarMenu');
                }
                if (!data) {
                    return;
                }
                value = data[option].apply(data, args);

            }
            if (!data) {
                $this.data('sidebarMenu',(data = new SidebarMenu(this, options)));
            }
        });
        return typeof value === 'undefined' ? this : value;
    };
    $.fn.sidebarMenu.Constructor = SidebarMenu;
    $.fn.sidebarMenu.defaults = SidebarMenu.DEFAULTS;
    $.fn.sidebarMenu.methods = methods;
    $(function() {
        $('[data-toggle="sidebarMenu"]').sidebarMenu();
    });
}));
