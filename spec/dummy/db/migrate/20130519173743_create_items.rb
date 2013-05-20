class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :from
      t.integer :till
      t.timestamps
    end
  end
end
