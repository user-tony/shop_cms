/*
 * jqtab by soni 03/08/2012
 */
(function ($) {
        function tabTo(wrapper,index){
            $('.gm-tabs-head a',wrapper).removeClass('current').eq(index).addClass('current');
            $('.gm-tabs-content',wrapper).removeClass('current').eq(index).addClass('current');
        }

    //自定义的加载 iframe 的方法
    $.fn.jqtab = function(o){
        var o = jQuery.extend({
            active: 'click'
        }, o);
        
        return this.each(function (index, wrapper){
            if(!this._jqtab){
                var theads = $('.gm-tabs-head a',wrapper).each(function(i,a){
                    $(a).attr('tindex',i);
                });
            
                if(o.active == 'hover'){
                    theads.hover(function(){
                        tabTo(wrapper,parseInt($(this).attr('tindex')));
                    },function(){}).click(function(){
                        this.blur();
                        return false;
                    });    
                }else{
                    theads.click(function(){
                        tabTo(wrapper,parseInt($(this).attr('tindex')));
                        this.blur();
                        return false;
                    }); 
                }
            
                
                var tcontents = $('.gm-tabs-content',wrapper).each(function(i,c){
                    $(c).attr('tindex',i);
                });   
                
                var currentIndex = 0;
                if($('.gm-tabs-head a.current',wrapper).length > 1){
                    currentIndex = parseInt($('.gm-tabs-head a.current',wrapper).attr('tindex'));
                }
                
                tabTo(wrapper,currentIndex);
                
                this._jqtab = true;
            }
        });    
    };

    $.fn.jqtabTo = function(i){
        this.each(function(index, wrapper){
            if(this._jqtab){
             tabTo(wrapper,i);
            }
        })
    };
})(jQuery);



