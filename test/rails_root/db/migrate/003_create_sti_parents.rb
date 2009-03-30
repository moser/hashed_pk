class CreateStiParents < ActiveRecord::Migration
  def self.up
   create_table :sti_parents do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :sti_parents
  end
end
