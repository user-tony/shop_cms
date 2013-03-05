#encoding: UTF-8

#作者：朱文博
#更新时间：2012-3-20

#给模板注册分页要素
class ActiveRecord::Relation
  def to_liquid
    self
  end
end

#上传插件模板注册
class Paperclip::Attachment
  def to_liquid
    self
  end
end


class ActiveRecord::Base
  # 扩展ActiveRecord::Base，添加按id查询没有则返回空
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-9
  def self.find_by_id(id, cache = false)
    return nil unless id
    cache ? Rails.cache.fetch("#{self.to_s.downcase}_find_by_id_#{id}"){ self.find(id) } : self.find(id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # 添加一个更新数据不改更新时间的方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-06-02  
  #
  # ==== 方法实例
  #      article = Article.first
  #      article.content = "内容"
  #      article.save_without_timestamping
  #
  # ==== 返回
  #   （true/false）
  #
  def save_without_timestamping
    class << self
      def record_timestamps; false; end
    end
    save
    class << self
      remove_method :record_timestamps
    end
  rescue ActiveRecord::RecordNotSaved
    nil
  end

end