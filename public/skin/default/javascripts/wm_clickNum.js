/* shop num input */

(function ($) {
        function replaceAllLetter(str){
            return str.replace(/\D/gi,'').replace(/^0/g,'');
        }
        function isPosnum(str){
            return parseInt(str) >= 0;
        }
        
        function fixedNumToPos(num){
            return isPosnum(num) ? num : 0;
        }
        
        function fixedInput(input){
            var fvalue = replaceAllLetter(input.value);
            input.value = fixedNumToPos(fvalue);
        }
        
        function changeInputValue(input,num){
            fixedInput(input);
            input.value = fixedNumToPos(parseInt(input.value) + num);
        }

    
    $.fn.wm_clickNum = function(o){
        var options = jQuery.extend({
            templete: '<div class="num-input"><span class="reduce"></span><span class="ninput"></span><span class="plus"></span></div>',
            change : function(input){},
            blur : function(input){},
            limit : function(input){}
        }, o);
        
        return this.each(function (index, input){
            if(!$(input).data('wm_clickNum')){
                var wrapper = $(options.templete);
                var svalue = this.value;
                $(input).before(wrapper).appendTo($('.ninput',wrapper)).focus(function(){
                    svalue = this.value;
                }).blur(function(){
                    fixedInput(this);
                    options.limit(input);
                    console.log(this.value);
                    if(this.value != svalue){
                        options.change(input);
                        svalue = this.value;
                    }
                    options.blur(this);
                });
                
                $('.reduce',wrapper).click(function(e){
                    changeInputValue(input,-1);
                    options.limit(input);
                    if(input.value != svalue){
                        options.change(input);
                        svalue = input.value;
                    }
                });
                $('.plus',wrapper).click(function(e){
                    changeInputValue(input,1);
                    options.limit(input);
                    if(input.value != svalue){
                        options.change(input);
                        svalue = input.value;
                    }
                });
                $(input).data('sourceValue',input.value);
                $(input).data('wm_clickNum',true);
            }
        });    
    };
})(jQuery);