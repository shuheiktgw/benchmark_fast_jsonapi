class CreateFjaEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :fja_employees do |t|
      t.references :fja_company
      t.string :name
      t.string :position
      t.integer :age

      t.timestamps
    end
  end
end
