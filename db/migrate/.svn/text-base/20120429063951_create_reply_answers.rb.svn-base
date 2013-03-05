class CreateReplyAnswers < ActiveRecord::Migration
  def change
    create_table :reply_answers, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.column :content,      :string                                    #回复内容
      t.column :management,   :integer,   :default => 0                  #是否为管理员回复
      #----------外键---------------------------------------------
      t.references :member                                               #空为匿名用户
      t.references :answer                                               #关联回答表

      t.timestamps
    end
  end
end
