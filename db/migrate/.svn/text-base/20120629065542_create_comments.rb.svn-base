class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments , :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column  :item_type,         :string                    # 父类类型
      t.column  :item_id,           :integer                   # 父类id
      t.column  :member_id,         :integer                   # 用户id
      t.column  :content,           :text                      # 内容
      t.column  :status,            :integer                   # 状态
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
