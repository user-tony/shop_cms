#encoding: UTF-8
class OrderAddress < ActiveRecord::Base
  
  acts_as_paranoid
  acts_as_list

  #注册模板字段
  mango_liquid %w(get_address)
  
  belongs_to :member
  belongs_to :area_country     #区
  belongs_to :area_city        #市
  belongs_to :area_province     #省
  has_many :orders
  


  def get_address
    "#{self.area_province.name}#{area_city.name}#{area_country.name}#{address}"
  end

  


end
