class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.column :title,              :string,          :null => false,             :limit => 50              #用户提问标题
      t.column :content,            :string,          :limit => 200                                         #回复内容
      t.column :answer_status,     :integer,          :default => 0                                          #回复状态
      t.column :remote_ip,         :string                                                                  #用户Ip
      t.column :name,              :string,            :limit =>40                #用户名
      t.column :qq,                :string,            :limit => 12                                         #用户QQ
      t.column :phone,             :string,             :limit => 15                                        #用户电话
      t.column :address,           :string,             :limit => 100                                       #用户地址

      #---------外键---------------------------------------------
      t.references :member                                                                                 #回复人
      t.references :channel                                                                                #栏目
      t.timestamps
    end
  end
end
