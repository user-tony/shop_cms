

//搜索页面添加购物车
function add_cert_list(){

    //购物车按钮
    $('.add-cert, .add-cart').each(function(index,item){
        addCert(item);
    });

    //添加购物车元素
    function addCert(ele){
        $(ele).poshytip({
            content: 'loading...',
            showOn: 'none',
            alignTo: 'target',
            alignX: 'center',
            alignY: 'bottom',
            offsetX: 0,
            offsetY: 5
        });

        //给元素添加点击事件
        $(ele).click(function(e){
            var that = this;
            var url = this.href;
            var query = getQuery(ele);

            $.ajax({
                url : url + '?' + query,
                error : function(){
                // error info
                },
                success : function(json){
                    var count = json.count;
                    updateShopCert(count);
                    $(that).poshytip('update', createPoshytipContent(json,ele));
                    $(that).poshytip('show');
                    window.setTimeout(function(){
                        $(that).poshytip('hide');
                    },5000);
                }
            });

            return false;
        });
    }
    function createPoshytipContent(shop,ele){
        var succ_message = '<div class="shop-cert-tip"><p class="title">商品添加成功！</p><p>商品名: '+ shop.name +'x'+ shop.price +'</p><p> <a href="/shop_products/my_cart" >去购物车结算</a></p></div>';
        var error_message = '<div class="shop-cert-tip shop-cert-tip-error"><p class="title">商品添加失败！</p><p>提示信息</p><p><a href="#" class="close">选择其它商品</a></p></div>';
        if (shop.status){
            var update = $(succ_message);
        }else{
            var update = $(error_message);
        }
        return update;
    }
    function getQuery(ele){
        var query = '';
        var parent = $(ele).parents('li').first();
        var id = parent.find('input[name="product_id"]').val();
        var num = parent.find('input[name="product_num"]').val() || 1;
        return 'id=' + id + '&num=' + num;
    }
}


function add_cert_show(){
    //添加购物车
    $('#add-cert').poshytip({
        content: 'loading...',
        showOn: 'none',
        alignTo: 'target',
        alignX: 'center',
        alignY: 'bottom',
        offsetX: 0,
        offsetY: 5
    });

    $('#add-cert').click(function(e){
        var that = this;
        var url = this.href;
        var query = getQuery();

        $.ajax({
            url : url + '?' + query,
            error : function(){
            // error info
            },
            success : function(json){
                $(that).poshytip('update', createPoshytipContent(json));
                $(that).poshytip('show');
                window.setTimeout(function(){
                    $(that).poshytip('hide');
                },5000);
                //加载购物车下拉框
                updateShopCert();
            }
        });

        return false;
    });
    //action pop windows
    function createPoshytipContent(shop){
        var succ_message = '<div class="shop-cert-tip"><p class="title">商品添加成功！</p><p>商品名: '+ shop.name +'x'+ shop.price +'</p><p> <a href="/shop_products/my_cart" >去购物车结算</a></p></div>';
        var error_message = '<div class="shop-cert-tip shop-cert-tip-error"><p class="title">商品添加失败！</p><p>提示信息</p><p><a href="#" class="close">选择其它商品</a></p></div>';
        if (shop.status){
            var update = $(succ_message);
        }else{
            var update = $(error_message);
        }
        $('.close',update).click(function(){
            $('#add-cert').poshytip('hide');
            return false;
        });
        return update;
    }

    function getQuery(){
        var id = $('#product_id').val();
        var num = $('#product_num').val();
        return 'id=' + id + '&num=' + num;
    }
}