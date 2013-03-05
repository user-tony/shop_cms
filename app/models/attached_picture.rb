#encondion: UTF-8
class AttachedPicture < ActiveRecord::Base

  #软删除
  #  acts_as_paranoid
  #多态
  belongs_to :item,  :polymorphic => true



  #图片
  has_attached_file :thumb, :styles => { :thumb => "130x200>"},
    :url => "/upload/thumbs/attached_pritrue/:id_partition/:style/:filename" ,
    :default_url   => "/assets/rails.jpg"
  #这个是以K计算的限制
  #  validates_attachment_size :thumb, :less_than => 10.kilobytes
  # 图片的大小限制为2M
  #  validates_attachment_size :thumb, :less_than => 8.megabytes
  #图片的支持类型
  validates_attachment_content_type :thumb, :content_type => [ 'image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']



  
end
