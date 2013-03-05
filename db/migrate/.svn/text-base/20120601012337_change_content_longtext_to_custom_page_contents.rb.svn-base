class ChangeContentLongtextToCustomPageContents < ActiveRecord::Migration
  def up
    change_column :custom_page_contents, :content, :longtext
  end

  def down
    change_column :custom_page_contents, :content, :text
  end
end
