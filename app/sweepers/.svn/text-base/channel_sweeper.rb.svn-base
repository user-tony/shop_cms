class ChannelSweeper < MainSweeper
  observe Channel

  private
  def expire_cache_for(channel)
    Rails.cache.delete("channel_by_#{channel.parent_id}")
    
    Rails.cache.delete("channel_find_by_id_#{channel.id}")
    Rails.cache.delete("channel_parent_id_by_#{channel.id}")

  end

end