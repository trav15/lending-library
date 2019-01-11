class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :available

      t.timestamps
    end
  end
end
