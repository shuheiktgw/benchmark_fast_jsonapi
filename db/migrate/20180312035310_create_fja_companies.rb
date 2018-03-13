class CreateFjaCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :fja_companies do |t|
      t.string :name

      t.timestamps
    end
  end
end
