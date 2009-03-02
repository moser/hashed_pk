class CreateHumanBeings < ActiveRecord::Migration
  def self.up
    create_table :human_beings do |t|
      t.string :name
      t.string :type
    end
  end

  def self.down
    drop_table :human_beings
  end
end
