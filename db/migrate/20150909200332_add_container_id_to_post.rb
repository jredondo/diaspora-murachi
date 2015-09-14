class AddContainerIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :container_id, :string
  end
end
