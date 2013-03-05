module Admin::MembersHelper
  
  def order_area(addr_id)
    _country = AreaCountry.find(addr_id)
    _city = _country.area_city
    _province = _city.area_province
    "#{_province.name}," + "#{_city.name}," + "#{_country.name} "
  end
  
end
