/*!
 * Cropper v3.0.0
 */

layui.config({
    base: '/static/js/extend/' //layui自定义layui组件目录
}).define(['jquery','layer','cropper'],function (exports) {
    var $ = layui.jquery
        ,layer = layui.layer;
    var html = "<link rel=\"stylesheet\" href=\"/static/css/extend/cropper.css\">\n" +
        "<div class=\"layui-fluid showImgEdit\" style=\"display: none\">\n" +
        "    <div class=\"layui-form-item\">\n" +
        "        <div class=\"layui-input-inline layui-btn-container\" style=\"width: auto;\">\n" +
        "            <label for=\"cropper_avatarImgUpload\" class=\"layui-btn layui-btn-primary\">\n" +
        "                <i class=\"layui-icon\">&#xe67c;</i>选择图片\n" +
        "            </label>\n" +
        "            <input class=\"layui-upload-file\" id=\"cropper_avatarImgUpload\" type=\"file\" value=\"选择图片\" name=\"file\">\n" +
        "        </div>\n" +
        "        <div class=\"layui-form-mid layui-word-aux\"></div>\n" +
        "    </div>\n" +
        "    <div class=\"layui-row layui-col-space15\">\n" +
        "        <div class=\"layui-col-xs9\">\n" +
        "            <div class=\"readyimg\" style=\"height:450px;background-color: rgb(247, 247, 247);\">\n" +
        "                <img src=\"\" >\n" +
        "            </div>\n" +
        "        </div>\n" +
        "        <div class=\"layui-col-xs3\">\n" +
        "            <div class=\"img-preview\" style=\"width:200px;height:200px;overflow:hidden\">\n" +
        "            </div>\n" +
        "        </div>\n" +
        "    </div>\n" +
        "    <div class=\"layui-row layui-col-space15\">\n" +
        "        <div class=\"layui-col-xs9\">\n" +
        "            <div class=\"layui-row\">\n" +
        "                <div class=\"layui-col-xs6\">\n" +
        "                    <button type=\"button\" class=\"layui-btn layui-icon layui-icon-left\" cropper-event=\"rotate\" data-option=\"-15\" title=\"Rotate -90 degrees\"> 向左旋转</button>\n" +
        "                    <button type=\"button\" class=\"layui-btn layui-icon layui-icon-right\" cropper-event=\"rotate\" data-option=\"15\" title=\"Rotate 90 degrees\"> 向右旋转</button>\n" +
        "                </div>\n" +
        "                <div class=\"layui-col-xs5\" style=\"text-align: right;\">\n" +

        // "                    <button type=\"button\" class=\"layui-btn\" title=\"移动\"></button>\n" +
        // "                    <button type=\"button\" class=\"layui-btn\" title=\"放大图片\"></button>\n" +
        // "                    <button type=\"button\" class=\"layui-btn\" title=\"缩小图片\"></button>\n" +

        "                    <button type=\"button\" class=\"layui-btn layui-icon layui-icon-refresh\" cropper-event=\"reset\" title=\"重置图片\"></button>\n" +
        "                </div>\n" +
        "            </div>\n" +
        "        </div>\n" +
        "        <div class=\"layui-col-xs3\">\n" +
        "            <button class=\"layui-btn layui-btn-fluid\" cropper-event=\"confirmSave\" type=\"button\"> 保存修改</button>\n" +
        "        </div>\n" +
        "    </div>\n" +
        "\n" +
        "</div>";
    var obj = {
        render: function(e){
            $('body').append(html);
            var self = this,
                elem = e.elem,
                saveW = e.saveW,
                saveH = e.saveH,
                mark = e.mark,
                area = e.area,
                url = e.url,
                done = e.done,
                commands = e.commands,
                appName = e.appName;



                if (url.lastIndexOf('?') == -1) {
                    url = url+"?application="+appName;
                }else{
                    url = url+"&application="+appName;
                }

                if (commands) {
                    commands = commands.split(',');
                    for ( var i = 0; i < commands.length; i++) {
                        $.trim(commands[i]);
                        url += '&command=' + $.trim(commands[i]);
                    }
                }


            var content = $('.showImgEdit')
                ,image = $(".showImgEdit .readyimg img")
                ,preview = '.showImgEdit .img-preview'
                ,file = $(".showImgEdit input[name='file']")
                , options = {aspectRatio: mark,preview: preview,viewMode:1,autoCropArea:1};

            $(elem).on('click',function () {
                layer.open({
                    type: 1
                    , content: content
                    , area: area
                    , success: function () {
                        image.cropper(options);
                    }
                    , cancel: function (index) {
                        layer.close(index);
                        image.cropper('destroy');
                    }
                });
            });
            $(".layui-btn").on('click',function () {
                var event = $(this).attr("cropper-event");
                if(event === 'confirmSave'){
                    //限制图片的格式，因为图片读出来都是base64格式的，所以直接截取base64中的图片类型判断格式。
                    var dataBase64 = $(image).attr('src');
                    var begin = dataBase64.indexOf("/");
                    var end = dataBase64.indexOf(";");
                    dataBase64 = dataBase64.substring(begin,end);
                    if ( dataBase64.toLowerCase() != "/jpg" && dataBase64.toLowerCase() != "/jpeg" && dataBase64.toLowerCase() != "/png"){
                                layer.alert("请上传指定的类型的图片(jpg,png,jpeg)!");
                                return false;
                    }
                    image.cropper("getCroppedCanvas",{
                        width: saveW,
                        height: saveH
                    }).toBlob(function(blob){
                        var formData=new FormData();
                        formData.append('file',blob,'head.jpg');
                        $.ajax({
                            method:"post",
                            url: url, //用于文件上传的服务器端请求地址
                            data: formData,
                            processData: false,
                            contentType: false,
                            asyn: false,
                            dataType: "json",
                            success:function(result){
                                if(result.retCode == 0){
                                    layer.msg("上传成功");
                                    layer.closeAll('page');
                                    return done(result.files[0].url);
                                }
                                else if (result.retCode == 12) {
                                    layer.msg("上传失败,请先登录太平洋通行证。");
                                } else if (result.retCode ==  14) {
                                    layer.msg("图片大小超过限制。");
                                } else {
                                    layer.msg('上传失败,请联系技术人员,错误编号: ' + result['retCode']);
                                }

                            },
                            error:function (result) {
                                layer.alert("上传失败=="+result.retCode == 0,{icon: 2});
                            }
                        });
                    });
                    //监听旋转
                }else if(event === 'rotate'){
                    var option = $(this).attr('data-option');
                    image.cropper('rotate', option);
                    //重设图片
                }else if(event === 'reset'){
                    image.cropper('reset');
                }
                //文件选择
                file.change(function () {
                    var r= new FileReader();
                    var f=this.files[0];
                    r.readAsDataURL(f);
                    r.onload=function (e) {
                        image.cropper('destroy').attr('src', this.result).cropper(options);
                    };
                });
            });
        }

    };
    exports('croppers', obj);
});