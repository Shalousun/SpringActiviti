<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="http://apps.bdimg.com/libs/bootstrap/3.3.4/css/bootstrap.css"/>
    <style>
        #login-container{
            margin-top:200px ;
        }
    </style>
    <script src="/statics/js/jquery/jQuery-2.2.0.min.js"></script>
    <script src="/statics/js/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<div id="login-container">
    <form action="/model/create" role="form" class="form-horizontal" method="post">
        <div class="form-group">
            <label for="name" class="control-label col-sm-3">名称：</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="name" name="name" title="流程名称" required>
            </div>
        </div>
        <div class="form-group">
            <label for="key" class="control-label col-sm-3">Key:</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="key" name="key" title="流程key" required>
            </div>
        </div>
        <div class="form-group">
            <label for="desc" class="control-label col-sm-3">描述:</label>
            <div class="col-sm-4">
                <textarea class="form-control" id="desc" name="description" rows="3" readonly></textarea>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-3 col-sm-10">
                <button type="submit" class="btn btn-primary" id="mySubmit">提交</button>
                <button type="reset" class="btn btn-default">重置</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>
