#encoding: UTF-8
class GlobalVariable < ActiveRecord::Base
  #------------------------------载-入-类----------------------------------------
  
  

  #------------------------------插---件-----------------------------------------
  #软删除
  acts_as_paranoid
  acts_as_list
  
  
  #------------------------------关---系-----------------------------------------
  #全局变量附件
  has_one :global_variable_attrachment, :dependent => :destroy
  belongs_to :global_variable_category
  
  #------------------------------常---量-----------------------------------------
 
#  VARIABLE_TYPES = {"整数" => 0, "字符串" => 1, "布尔" => 2, "text" => 3, "图片" => 4, "复选框" => 5}
  VARIABLE_TYPES = {"integer" => 0, "string" => 1, "" => 2, "text" => 3, "picture" => 4, "check_box" => 5, "array" => 6}
  
  #------------------------------scope------------------------------------------
  #按照变量类型匹配
  scope :by_var_type, lambda{|type| where("var_type = ?", type)}
  #按照名称模糊匹配
  scope :by_name, lambda{|name| where("name like ?", "%#{name}%")}
  #按照键名模糊匹配
  scope :by_key_name, lambda{|key| where("key_name like ?", "%#{key}%")}

  scope :find_by_key_name, lambda{|key_name| where("key_name =? ", key_name)}
  
  #------------------------------验---证-----------------------------------------
  #验证键名
  validates :key_name, :presence => { :message => "键名不能为空！" },:uniqueness => true,
    :length => { :minimum => 1, :maximum => 50, :message => "键名长度应介于1-50！" },
    :format => { :with => /^[a-zA-Z0-9_]*$/, :message => "键名不能包含特殊字符！" }
  #验证变量类型
  validates :var_type, :presence => { :message => "类型不能为空！"}
#  validates_as_paranoid
  
  #------------------------------类-方-法----------------------------------------
  
  # 查询网站全局变量
  #
  # 作者：李季
  # 最后更新时间： 2012-3-19
  def self.global_var
    $cms_global_variable = self.order("id desc").inject({}) do |hash, v|
      if v.var_type == 0
        hash[v.key_name] = v.content.to_i
      elsif v.var_type == 4
        if v.global_variable_attrachment.present?
          hash[v.key_name] = v.global_variable_attrachment.thumb.url
        else
          hash[v.key_name] = nil
        end
      elsif v.var_type == 6
         hash[v.key_name] = v.content.split("#")
      else
          hash[v.key_name] = v.content
      end
      hash
    end
  rescue
    nil
  end
  #------------------------------实例方法-----------------------------------------
  

end
