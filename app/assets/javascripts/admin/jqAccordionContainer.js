/*
 * jqAccordionContainer
 *
 * Copyright (c) 2012 Transping
 * $Version: 03/07/2012 +0.1
 */
(function ($) {
	$.fn.jqAccordionContainer = function (o) {
		var p = $.extend({
			toggle : 'click',   //hover, click
			one : true,
			click : function(e){}
		}, o);
        
		return this.each(function () {
            if(!this._jqac){
                var jqac = this;

                $('li',jqac).addClass('no-child').has('ul').removeClass('no-child');
                
                $('li',jqac).bind(p.toggle,function(e){
                    var li = this;
                
                    if($('ul',li).length > 0){    //parent
                        if($(li).hasClass('open')){
                            $(li).children('ul').slideUp('fast',function(){
                                $(li).removeClass('open');
                            });
                        }else{
                            $(li).children('ul').slideDown('fast',function(){
                                $(li).addClass('open');
                            });
                        }
                        
                        e.preventDefault();
                    }else{
                        if(p.click.call(this,e) === false){ e.preventDefault(); }
                    }
                    
                    e.stopPropagation();
                });
                
                
                jqac._jqac = true;
            }
		});
	};
})(jQuery);



