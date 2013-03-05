#encoding: UTF-8
module Admin::GlobalVariablesHelper
  
  def content_format(var, num)
    # 类型说明：  integer: 0, string: 1, boolean: 2, text: 3, image: 4
    #
    # 作者：李季
    # 更新时间：2012-3-8
    if var.var_type == 2                                             
      _format = (radio_button_tag "variable[#{num}][content]", true, (true if var.content == "true")) 
      _format = _format +(label_tag  "variable[#{num}][content][true]", "是")
      _format = _format + (radio_button_tag "variable[#{num}][content]", false, (true if var.content == "false"))
      _format = _format + (label_tag "variable[#{num}][content][false]", "否")
    elsif var.var_type == 3
      text_area_tag "variable[#{num}][content]" , var.content, :size => "85x5"
    elsif var.var_type == 4
      new_or_edit_img(var)
    elsif var.var_type == 5
      check_box_tag "variable[#{num}][content]" , "true", var.content == "true" ? true : false
    else
      text_field_tag "variable[#{num}][content]", var.content, :size => 75
    end
  end
  
  def new_or_edit_img(var)
     if var.global_variable_attrachment.present? 
      link_to("修改图片", '#', :title => "修改#{var.name}的图片", :class => "thickbox","data-iframe-src" => edit_image_admin_global_variable_path(var.id))
    else
      link_to("添加图片", '#', :title => "添加#{var.name}的图片", :class => "thickbox","data-iframe-src" => new_image_admin_global_variable_path(var.id))  
    end

    

  end
  
end
