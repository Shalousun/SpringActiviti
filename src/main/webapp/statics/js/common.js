$(function(){
	calcIndex();//执行计算右边区域高度
	calcContent();//执行计算动态显示区域高度

	function getEleHeight(obj){//获取元素高度
		return $(obj).outerHeight();
	}

	function getEleWidth(obj){//获取元素宽度
		return $(obj).outerWidth();
	}

	function calcIndex(){//计算右边区域高度
		var fullHeight=getEleHeight(".wrapper");
	 	  navHeight=getEleHeight(".main-header");
		$("#content-wrapper").outerHeight((fullHeight-navHeight-1))
	}

	function calcContent(){//计算动态显示区域高度
		var conHeight=getEleHeight("#content-wrapper");

		tabHeight=getEleHeight(".content-tabs");
		$(".content-iframe").outerHeight((conHeight-tabHeight));
		console.log($(".content-iframe").outerHeight())
	}

	$(window).resize(function(){//窗口大小放生变化时执行高度重计算
      	calcIndex();
		calcContent();
    })
	
	$(".boco-tabs .boco-tab").on("click",function(){
		$(this).addClass("boco-tab-on").siblings().removeClass("boco-tab-on");
		var tabIndex=$(this).index();
		$(".table-tab").eq(tabIndex).removeClass("table-tab-hide").siblings().addClass("table-tab-hide");
	})

})