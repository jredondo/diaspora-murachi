class AddCertificateToPost < ActiveRecord::Migration
  def change
    add_column :posts, :certificate, :string
  end
end
