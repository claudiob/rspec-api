class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :where
      t.integer :year

      t.timestamps
    end
  end
end
