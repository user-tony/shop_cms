class MainSweeper < ActionController::Caching::Sweeper

  def after_create(post)
    expire_cache_for(post)
  end

  def after_update(post)
    expire_cache_for(post)
  end
  
  def after_destroy(post)
    expire_cache_for(post)
  end
  
  private
  def expire_cache_for(record)

  end
  
end