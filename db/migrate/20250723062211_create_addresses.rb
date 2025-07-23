class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :line1
      t.string :line2
      t.string :city
      t.string :zip
      t.string :address_type

      t.timestamps
    end
  end
end
