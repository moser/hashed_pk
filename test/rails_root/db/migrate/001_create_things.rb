class CreateThings < ActiveRecord::Migration
  def self.up
   create_table :things do |t|
      t.string :id
      t.string :name
    end
    change_column :things, :id, :string
  end

  def self.down
    drop_table :things
  end
end
