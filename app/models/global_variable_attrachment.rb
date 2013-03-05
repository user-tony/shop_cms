class GlobalVariableAttrachment < ActiveRecord::Base
  #软删除
  acts_as_paranoid
  acts_as_list
  
  #全局变量
  belongs_to :global_variable
  
  
  has_attached_file :thumb, :styles => { :thumb => "130x200>", :small => "32x32>"},
    :url => "/upload/thumbs/global_variable_attrachment/:id_partition/:style/:filename",
    :default_url   => "/assets/rails.png"
  #这个是以K计算的限制
  #  validates_attachment_size :thumb, :less_than => 10.kilobytes
  # 图片的大小限制为2M
  validates_attachment_size :thumb, :less_than => 8.megabytes
  #图片的支持类型
  validates_attachment_content_type :thumb, :content_type => [ 'image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg','image/vnd.microsoft.icon']


  
end
