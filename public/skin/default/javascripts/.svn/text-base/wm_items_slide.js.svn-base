/* products img slide */

(function ($) {
    $.fn.wm_items_slide = function(){
        var bigImg = $('.big img',this);
        var current = null;

        $('ul li',this).hover(function(e){
            if(current){
                current.removeClass('current');
            }
            current = $(this).addClass('current');
            var src = $('img',current).attr('big-src');
            bigImg.attr('src',src);
        });
    };
})(jQuery);
