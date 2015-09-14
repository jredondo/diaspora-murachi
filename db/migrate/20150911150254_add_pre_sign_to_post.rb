class AddPreSignToPost < ActiveRecord::Migration
  def change
    add_column :posts, :presign, :string
  end
end
