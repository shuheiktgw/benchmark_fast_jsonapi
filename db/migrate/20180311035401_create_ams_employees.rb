class CreateAmsEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :ams_employees do |t|
      t.references :ams_company
      t.string :name
      t.string :position
      t.integer :age

      t.timestamps
    end
  end
end
