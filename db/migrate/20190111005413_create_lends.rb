class CreateLends < ActiveRecord::Migration[5.2]
  def change
    create_table :lends do |t|
      t.datetime :lend_date
      t.datetime :return_date

      t.timestamps
    end
  end
end
