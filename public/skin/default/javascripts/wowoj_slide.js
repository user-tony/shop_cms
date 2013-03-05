jQuery.fn.extend({
  wowoj_slide: function(options) {
    
    var o = jQuery.extend({
        delay : 3000,       //切换间隔
        hoverPause: true    //鼠标暂停
    }, options);
    o.width = o.width || $(this).find('a:first img').width();
    o.height = o.height || $(this).find('a:first img').height();
    
    var wrapper = $('<div class="wowoj_slide"></div>');
    var ol = $('<ol class="wowoj_slide_list"></ol>');
    var slideItems = [];
    var slideOls = [];
    var activeIndex;    //当前 slide
    var runtime = 0;
    var delay = 100;
    var timeHandler = null;
    var fading = false;
    var pause = false;
    
    function slideStart(){
        activeIndex = 0;
        runtime = 0;
        slideItems[activeIndex].fadeIn('normal',function(){
            slideOls[activeIndex].addClass('active');
            timeHandler = window.setInterval(slideRun, delay);
        });
    }
    
    function slideTo(index){
        fading = true;
        runtime = 0; 
        
        slideOls[activeIndex].removeClass('active');
        slideItems[activeIndex].fadeOut('normal',function(){
            activeIndex = index;
            
            slideOls[activeIndex].addClass('active');
            slideItems[activeIndex].fadeIn('normal',function(){
                fading = false;
            });    
        });
    }
     
    function slideRun(){
        if(!fading && !pause){
            if(runtime < o.delay){
                runtime += delay;
            }else{
                fading = true;
                slideNext();
            }
        }
    }
    
    function slidePause(){
        pause = true;
    }
    function slidePlay(){
        pause = false;
    }
    function slideNext(){
        runtime = 0;   
        
        slideOls[activeIndex].removeClass('active');
        slideItems[activeIndex].fadeOut(function(){
            if(activeIndex >= slideItems.length - 1){
                activeIndex = 0;
            }else{
                activeIndex++;
            }
            
            slideOls[activeIndex].addClass('active');
            slideItems[activeIndex].fadeIn('normal',function(){
                fading = false;
            });     
        });
    }
    
    
    $('li', this).each(function(index, domEle){
        var slideItem = $('<div class="wowoj_slide_item"></div>').append($('<p>'+$('img',domEle).attr('alt')+'</p>')).prepend($(domEle).find('a'));
        
        $('img',slideItem).removeAttr('alt');
        
        if(o.hoverPause){
            slideItem.hover(function(){
                slidePause();
            },function(){
                slidePlay();
            });
        }
        
        slideItem.find('a').click(function(e){
            window.open(this.href);
            e.preventDefault();
        });
        
        
        var liItem = $('<li slide_index="'+index+'"><a href="#">'+(index+1)+'</a></li>').click(function(){
            slideTo(parseInt($(this).attr('slide_index')));
            $('a',this).blur(); //去除虚线
        });
        
        if(o.hoverPause){
            liItem.hover(function(){
                slidePause();
            },function(){
                slidePlay();
            });
        }
        
        slideOls.push(liItem);
        slideItems.push(slideItem);
        wrapper.append(slideItem);
        ol.append(liItem);
    });    
    
    wrapper.append(ol).css('width',o.width+'px').css('height',o.height+'px');
    wrapper.insertAfter(this);
    $(this).remove();
    
    slideStart();
    return wrapper;
  }
});