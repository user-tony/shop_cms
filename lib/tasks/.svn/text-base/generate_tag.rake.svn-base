#encoding: UTF-8
namespace :mangocms do
  desc "生成标签"
  task :generate_tag => :environment do
    begin
         Article.ct_desc.find_each(:batch_size => 200) do |article|
          next unless article && article.article_content
          article.tag_list = TagTools.get_tags(article.title, article.article_content.content)
          article.save
           p article.tag_list
         end
    rescue
      p "生成标签出错"
        nil  
    end
  end
end