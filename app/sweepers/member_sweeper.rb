class MemberSweeper < MainSweeper
  observe Member

  private
  def expire_cache_for(record)
    Rails.cache.delete("member_#{record.id}")
  end
  
end