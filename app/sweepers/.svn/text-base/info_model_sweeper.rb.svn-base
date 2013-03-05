class InfoModelSweeper < MainSweeper
  observe InfoModel

  private
  def expire_cache_for(record)
    Rails.cache.delete("info_model_all")
    Rails.cache.delete("info_model_#{record.id}")
  end
  
end