class AddSignsAssociationToPost < ActiveRecord::Migration
  def change
    create_table :signings do |t|
      t.belongs_to :post, index: true
      t.belongs_to :sign, index: true
      #t.datetime :sign_date
      t.timestamps null: false
    end
  end
end
