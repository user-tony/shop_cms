class FriendlyWebsiteSweeper < MainSweeper
  observe FriendlyWebsite

  private
  def expire_cache_for(record)
    Rails.cache.delete("friendly_website_all")
  end
  
end