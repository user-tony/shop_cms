$(document).ready(function(e){
    
    //side menu
    try{
        $('.gm-accordion-container').jqAccordionContainer({
            click : function(e){
                $('#s-right-wrapper').load(e.target.href);
                return false;
            }
        });
    }catch(e){}
    
    //tab
    try{
        $('.gm-tabs').jqtab();
    }catch(e){}
    
    //date picker
    try{
        $('.date-picker').datepick({
            dateFormat: 'yyyy/mm/dd'
        });
    }catch(e){}

    //side menu
    try{
        $('.gm-bloc').each(function(index,ele){
            if($(this).hasClass('lock')){
                return;
            }
            $('.gm-bloc-head',ele).click(function(){
                if($(ele).hasClass('hide')){
                    $(ele).removeClass('hide');
                    $('.gm-bloc-body',ele).slideDown();
                }else{
                    $('.gm-bloc-body',ele).slideUp(function(){
                        $(ele).addClass('hide');
                    })
                }
            });
        });
    }catch(e){}

    //fixed height
    (function(){
        function fixedHeight(){
            var right = $('.s-container .s-content');
            var left = $('.s-container .s-rail');
            
            right.height('auto');
            left.height('auto');
            
            var leftHeight = left.height();
            var rightHeight = right.height();
            
            var height = Math.max(leftHeight,rightHeight);
            
            var winHeight = $(window).height(); 
            var docHeight = $(document.body).outerHeight(); 
            if(winHeight > docHeight){
                height = winHeight - $('body > .s-head').outerHeight() - $('body > .s-copyright').outerHeight();
            }
            left.css('height',height);
        }
        window.setInterval(fixedHeight,2000);
        fixedHeight();
    })();


    //table select toggle
    try{
        $('.s-table .selectAll').live("click", function(){
            var ptable = $(this).parents('.s-table').first();
            if(this.checked){
                //selectAll
                $('tbody input[type=checkbox]',ptable).attr('checked',true);
            }else{
                //cancel select
                $('tbody input[type=checkbox]',ptable).attr('checked',false);
            }
        });
    }catch(e){}
});

function gm_hide_tips(str){
    //    var notice
    //    (<strong>成功: </strong><span>所有变量更新成功！</span>
    var tip = $('<div class="s-notif s-success">'+  +'</div>');
    $('#wid').append(tip);
    
    window.setTimeout(function(){
        tip.hide('slow');
    },5000);
}





function gm_formValidateSubmit(formId){
      $('#'+ formId).validate({
        submitHandler:function(form){
          if(!$(form).data('remote')){
            if($(form).data('submiting')){ return false; }

            var loading = $('正在提交，请稍后...');
            $(form).before(loading);
            $(form).data('submiting','true');
            form.submit();
          }
        }
      });
    }