class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :phone
      t.string :mobile_phone
      t.string :email
      t.references :employee, foreign_key: true

      t.timestamps
    end
    add_index :contacts, :email, unique: true
  end
end
