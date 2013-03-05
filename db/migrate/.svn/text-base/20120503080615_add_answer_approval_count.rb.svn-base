class AddAnswerApprovalCount < ActiveRecord::Migration
  def up
    self.add_column :answers , :approval_count,  :integer , :default => 0        #赞成数
  end

  def down
    self.remove_column(:answers, :approval) 
  end
end
