# Firmas para sistema de puntos de cuenta
# Jorge Redondo Flames. CENDITEL

class CreateSigns < ActiveRecord::Migration
  def change
    create_table :signs do |t|
      t.string :body
      t.references :signable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
