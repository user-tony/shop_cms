function ProductItem(w,o){
        this._wrapper = w;
        this._ajaxs = [];
        this._request = null;
        this._loading = false;
        this._options = jQuery.extend({
          change : function(input){},
          callback : function(wrapper){
            console.log('callback');
          }
        }, o);

        this._init();
      }
      //是否已选择
      ProductItem.prototype.hasSelected = function(){
        if($('.select-line', this._wrapper).attr('checked')){
          return true;
        }
        return false;
      };
      //选择行
      ProductItem.prototype.select = function(){
        $('.select-line', this._wrapper).attr('checked','checked');
      };
      //取消选择行
      ProductItem.prototype.unselect = function(){
        $('.select-line', this._wrapper).removeAttr('checked');
      };
      //添加ajax队列
      ProductItem.prototype.pushAjax = function(options){
        var item = this;
        var o = jQuery.extend({}, options);
        if(o.complete){
          var scomplete = o.complete;
          o.complete = function(jqXHR, textStatus){
            scomplete(jqXHR, textStatus);
            item.nextAjax();
          };
        }else{
          o.complete = function(jqXHR, textStatus){
            item.nextAjax();
          };
        }

        this._ajaxs.push(function(){
          return $.ajax(o);
        });
      };
      //终止ajax请求
      ProductItem.prototype.abortAjax = function(){
        if(this._request){
          this._request.abort();
          this._loading = false;
        }
      };
      //执行ajax队列
      ProductItem.prototype.nextAjax = function(){
        this._ajaxs.shift();
        this.ajax();
      };
      //取得ajax队列
      ProductItem.prototype.getAjaxs = function(){
        return this._ajaxs;
      };
      //执行ajax请求
      ProductItem.prototype.ajax = function(){
        this._loading = false;
        if(this._ajaxs.length > 0){
          this._request = this._ajaxs[0]();
          this._loading = true;
        }
      };
      //是否在执行ajax请求
      ProductItem.prototype.loading = function(){
        return this._loading;
      };
      //移除 item
      ProductItem.prototype.remove = function(){
        this.abortAjax();
        $(this._wrapper).detach();
      };

      //初始化
      ProductItem.prototype._init = function(){
        this._initClickNum();   //数量
        this._initBtns();   //功能按钮
      };
      //初始化产品数量
      ProductItem.prototype._initClickNum = function(){
        var that = this;

        $('.products-num',this._wrapper).wm_clickNum({
          change : function(input){
            that._options.change.call(that,input);
          },
          limit : function(input){
            if(parseInt(input.value) < 1){
              input.value = 1;
            }
          }
        });
      };
      //初始化按钮
      ProductItem.prototype._initBtns = function(){
        this._options.callback.call(this,this._wrapper);
      };

