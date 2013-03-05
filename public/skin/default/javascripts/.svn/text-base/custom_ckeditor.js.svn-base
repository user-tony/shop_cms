/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/


CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	
  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
//  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
//  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
//  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";
  
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
//  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
//  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
//  config.filebrowserImageUploadUrl = "/ckeditor/pictures";
  
  // The location of a script that handles file uploads.
//  config.filebrowserUploadUrl = "/ckeditor/attachment_files";
  
  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token = jQuery('meta[name=csrf-token]').attr('content'),
        csrf_param = jQuery('meta[name=csrf-param]').attr('content'),
        params = new Object();
    
    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }
    
    return params;
  };
  
  /* Extra plugins */
  // works only with en, ru, uk locales
  config.extraPlugins = "embed,attachment";
  
  /* Toolbars */
  config.toolbar = 'Tlj';
  config.content = "ddddd";
  config.width = '800';
  config.language = 'zh-cn';
  config.height = '400';
  config.format_pre = { element : 'div' };
  config.font_names='宋体/宋体;MS Mincho/MS Mincho;MS Gothic/MS Gothic;Batang/Batang;Gulim/Gulim;隶书/隶书;微软雅黑/微软雅黑;'+ config.font_names;
  
  config.filebrowserBrowseUrl = false;
  config.toolbar_Tlj =
    [
        ['Source','-','Preview'],
        ['Cut','Copy','Paste','PasteText','PasteFromWord',],
        ['Undo','Redo','-','SelectAll','RemoveFormat'], '/',
        ['Styles','Format','Font', 'FontSize'], ['Subscript', 'Superscript', 'TextColor'], ['Maximize','-','About'], '/',
        ['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Link','Unlink','Anchor'] ,
        ['Table','HorizontalRule','Smiley','SpecialChar','PageBreak']
    ];
    
  
};
