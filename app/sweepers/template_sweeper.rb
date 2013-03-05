class TemplateSweeper < MainSweeper
  observe Template

  private
  def expire_cache_for(record)
    Rails.cache.delete("template_type_#{record.template_type}")
    Rails.cache.delete("template_find_by_id_#{record.id}")       
  end
  
end