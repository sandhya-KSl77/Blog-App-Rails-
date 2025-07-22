class RemoveCommenterFromComments < ActiveRecord::Migration[8.0]
  def change
    remove_column :comments, :commenter, :string
  end
end
