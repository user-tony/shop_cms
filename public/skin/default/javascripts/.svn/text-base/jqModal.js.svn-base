/*
 * jqModal - Minimalist Modaling with jQuery
 *   (http://dev.iceburg.net/jquery/jqModal/)
 *
 * Copyright (c) 2007,2008 Brice Burgess <bhb@iceburg.net>
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * $Version: 03/01/2009 +r14
 
 * extends by soni 03/07/2012
 */
(function ($) {
	$.fn.jqm = function (o) {
		var p = {
			overlay : 50,
			overlayClass : 'jqmOverlay',
			closeClass : 'jqmClose',
			trigger : '.jqModal',
			ajax : F,
			ajaxText : '<div class="jqModal-loading"><img src="../images/loader.gif" alt="loading" /></div>',
			target : F,
			modal : F,
			toTop : F,
			onShow : F,
			onHide : F,
			onLoad : F
		};
		return this.each(function () {
			if (this._jqm)
				return H[this._jqm].c = $.extend({}, H[this._jqm].c, o);
			s++;
			this._jqm = s;
			H[s] = {
				c : $.extend(p, $.jqm.params, o),
				a : F,
				w : $(this).addClass('jqmID' + s),
				s : s
			};
			if (p.trigger)
				$(this).jqmAddTrigger(p.trigger);
		});
	};
	
	$.fn.jqmAddClose = function (e) {
		return hs(this, e, 'jqmHide');
	};
	$.fn.jqmAddTrigger = function (e) {
		return hs(this, e, 'jqmShow');
	};
	$.fn.jqmShow = function (t) {
		return this.each(function () {
			t = t || window.event;
			$.jqm.open(this._jqm, t);
		});
	};
	$.fn.jqmHide = function (t) {
		return this.each(function () {
			t = t || window.event;
			$.jqm.close(this._jqm, t)
		});
	};
	
	$.jqm = {
		hash : {},
		open : function (s, t) {
			var h = H[s],
			c = h.c,
			cc = '.' + c.closeClass,
			z = (parseInt(h.w.css('z-index'))),
			z = (z > 0) ? z : 3000,
			o = $('<div></div>').css({
					height : '100%',
					width : '100%',
					position : 'fixed',
					left : 0,
					top : 0,
					'z-index' : z - 1,
					opacity : c.overlay / 100
				});
			if (h.a)
				return F;
			h.t = t;
			h.a = true;
			h.w.css('z-index', z);
			if (c.modal) {
				if (!A[0])
					L('bind');
				A.push(s);
			} else if (c.overlay > 0)
				h.w.jqmAddClose(o);
			else
				o = F;
			
			h.o = (o) ? o.addClass(c.overlayClass).prependTo('body') : F;
			if (ie6) {
				$('html,body').css({
					height : '100%',
					width : '100%'
				});
				if (o) {
					o = o.css({
							position : 'absolute'
						})[0];
					for (var y in {
						Top : 1,
						Left : 1
					})
						o.style.setExpression(y.toLowerCase(), "(_=(document.documentElement.scroll" + y + " || document.body.scroll" + y + "))+'px'");
				}
			}
			
			if (c.ajax) {
				var r = c.target || h.w,
				u = c.ajax,
				r = (typeof r == 'string') ? $(r, h.w) : $(r),
				u = (u.substr(0, 1) == '@') ? $(t).attr(u.substring(1)) : u;
				r.html(c.ajaxText).load(u, function () {
					if (c.onLoad)
						c.onLoad.call(this, h);
					if (cc)
						h.w.jqmAddClose($(cc, h.w));
					e(h);
				});
			} else if (cc)
				h.w.jqmAddClose($(cc, h.w));
			
			if (c.toTop && h.o)
				h.w.before('<span id="jqmP' + h.w[0]._jqm + '"></span>').insertAfter(h.o);
			(c.onShow) ? c.onShow(h) : h.w.show();
			e(h);
            window.global_jqModal = h;
			return F;
		},
		close : function (s) {
			var h = H[s];
			if (!h.a)
				return F;
			h.a = F;
			if (A[0]) {
				A.pop();
				if (!A[0])
					L('unbind');
			}
			if (h.c.toTop && h.o)
				$('#jqmP' + h.w[0]._jqm).after(h.w).remove();
			if (h.c.onHide)
				h.c.onHide(h);
			else {
				h.w.hide();
				if (h.o)
					h.o.remove();
			}
			return F;
		},
		params : {}
		
	};
	var s = 0,
	H = $.jqm.hash,
	A = [],
	ie6 = $.browser.msie && ($.browser.version == "6.0"),
	F = false,
	i = $('<iframe src="javascript:false;document.write(\'\');" class="jqm"></iframe>').css({
			opacity : 0
		}),
	e = function (h) {
		if (ie6)
			if (h.o)
				h.o.html('<p style="width:100%;height:100%"/>').prepend(i);
			else if (!$('iframe.jqm', h.w)[0])
				h.w.prepend(i);
		f(h);
	},
	f = function (h) {
		try {
			$(':input:visible', h.w)[0].focus();
		} catch (_) {}
		
	},
	L = function (t) {
		$()[t]("keypress", m)[t]("keydown", m)[t]("mousedown", m);
	},
	m = function (e) {
		var h = H[A[A.length - 1]],
		r = (!$(e.target).parents('.jqmID' + h.s)[0]);
		if (r)
			f(h);
		return !r;
	},
	hs = function (w, t, c) {
		return w.each(function () {
			var s = this._jqm;
			$(t).each(function () {
				if (!this[c]) {
					this[c] = [];
					$(this).click(function () {
						for (var i in {
							jqmShow : 1,
							jqmHide : 1
						})
							for (var s in this[i])
								if (H[this[i][s]])
									H[this[i][s]].w[i](this);
						return F;
					});
				}
				this[c].push(s);
			});
		});
	};
    
    
    //自定义的加载 iframe 的方法
    $.fn.jqmIframe = function(o){
            var o = jQuery.extend({
                modal: true,
                onShow: openInFrame,
                onHide: closeModal
            }, o);
            
            this.jqm(o);
            
            function openInFrame(hash){
                //窗口标题
                $('.head .jqmTitleText',hash.w).html($(hash.c.trigger).attr('title'));
                
                //预加载
                var wrapper = $('.body',hash.w).html('');
                var pload = $('<div class="jqModal-loading"><img src="../images/loader.gif" alt="loading" /></div>');
                wrapper.append(pload);
                
                //size
                var width = Math.floor(parseInt($(window).width()  * 0.8));
                var height = Math.floor(parseInt($(window).height()  * 0.9));
                var left = Math.floor(($(window).width() - width)/2);
                var top = Math.floor(($(window).height() - height)/2);
                
                hash.w.css('width',width).css('left',left).css('top',top).css('margin',0).show();
                wrapper.css('height',height-100).css('background','#eee');
                
                //加载 iframe
                var iframe = $('<iframe src="'+$(hash.c.trigger).data('iframe-src')+'" frameborder="0"></iframe>').get(0);
                wrapper.append(iframe);
                
                if (iframe.attachEvent){
                    iframe.attachEvent("onload", loadComplete);
                }else{
                    iframe.onload = loadComplete;
                }
                
                function loadComplete(){
                    pload.remove();
                    
                    //注册全局窗口对象，供 iframe 页面调用
                    //window.global_jqModal = hash;
                }
            }
            
            function closeModal(hash){
                var modalWindow = $(hash.w);

                modalWindow.fadeOut('2000', function(){
                    hash.o.remove();
                    //refresh parent
                    if (hash.c.refreshAfterClose){
                        window.location.reload();
                    }
                });
            };
            return this;
    };
    
    $.jqmIframe = function(o){
        $(o.trigger).each(function(index,ele){
            var o = jQuery.extend(o, {trigger: ele});
            $('<div class="jqmWindow jqiframe"><div class="head">'+$(ele).attr('title')+'<a href="#" class="jqmClose">关闭</a></div><div class="body"></div></div>').appendTo(document.body).jqmIframe(o);
        });
    };
    
    
    $.jqmClose = function(){
        try{
            window.parent.global_jqModal.w.jqmHide();
            window.parent.global_jqModal = null;
        }catch(e){}
    };
    
    $.jqmAlert = function(str,title){
        var title = title || '提示';
    
        $('<div class="jqmWindow alert"><div class="head">'+title+'</div><div class="body">'+str+'</div><div class="foot"><div class="s-input"><input type="button" value="确定" class="jqmClose" /></div></div></div>').appendTo(document.body).jqm({modal:true}).jqmShow();
    };
    
    $.jqmRemoteAlert = function(href){
        var s = $('<div class="jqmWindow alert"></div>').appendTo(document.body).jqm({ajax: 'foo.h', modal:true});
        $.ajax({
            url: href, 
            dataType : 'json',
            success: function(data, textStatus, jqXHR){
                s.jqmHide();
                $.jqmAlert(data.msg,data.title);
            }
        });
    };
    
    $.jqmConfirm = function(str,callback,title){
        var title = title || '确认信息';
    
        $('<div class="jqmWindow alert"><div class="head">'+title+'</div><div class="body">'+str+'</div><div class="foot"><div class="s-input"><input type="button" value="确定" class="p-confirm" /><input type="button" value="取消" class="uncen jqmClose" /></div></div></div>').appendTo(document.body).jqm({modal:true,onShow:function(hash){
            $('.p-confirm',hash.w).click(function(e){ 
                if(callback(hash) !== false){
                    hash.w.jqmHide(); 
                }
            });
            hash.w.show();
        }}).jqmShow();
    };
    
    $.jqmAjaxConfirm = function(href,callback){
        var s = $('<div class="jqmWindow alert"></div>').appendTo(document.body).jqm({ajax: 'foo.h', modal:true});
        $.ajax({
            url: href, 
            dataType : 'json',
            success: function(data, textStatus, jqXHR){
                s.jqmHide();
                $.jqmConfirm(data.msg,callback,data.title);
            }
        });
    };
    
    $.jqmResize = function(width,height){
        if(window.global_jqModal){
            var hash = window.global_jqModal;
            var wrapper = $('.body',hash.w);
            
            //size
            var left = Math.floor(($(window).width() - width)/2);
            var top = Math.floor(($(window).height() - height)/2);
        
            hash.w.css('width',width).css('left',left).css('top',top).css('margin',0);
            wrapper.css('height',height-100);
        }
    }
    
    $.jqmFullWindow = function(){
        if(window.global_jqModal){
            var hash = window.global_jqModal;
            var wrapper = $('.body',hash.w);
            
            //size
            var left = 0;
            var top = 0;
        
            hash.w.css('width',$(window).width()).css('left',left).css('top',top).css('margin',0);
            wrapper.css('height',$(window).height()-100);
        }
    }
    
})(jQuery);



