
var startTime = {
    elem : '#startTime',
    format : 'YYYY-MM-DD',
    max : laydate.now(),
    istoday : true,
    choose : function(data) {
        endTime.min = data; // 开始日选好后，重置结束日的最小日期
        endTime.start = data // 将结束日的初始值设定为开始日
    }
};

var endTime = {
    elem : '#endTime',
    format : 'YYYY-MM-DD',
    max : laydate.now(),
    istoday : true,
    choose : function(data) {
        startTime.max = data; // 结束日选好后，重置开始日的最大日期
    }

}
laydate(startTime);
laydate(endTime);
