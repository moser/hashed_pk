require File.dirname(__FILE__) + '/../../test/test_helper'
class SecondThing < ActiveRecord::Base
  set_table_name "things"
  has_hashed_primary_key :length => 4 #max id = 2**4 - 1 = 15
end

class FourthThing < ActiveRecord::Base
  set_table_name "things"
  has_hashed_primary_key :init_string => lambda { "static" }
end

class NormTest < Test::Unit::TestCase
  def setup
    Thing.delete_all
    HumanBeing.delete_all
  end
  
  def test_should_not_create_duplicates
    t = FourthThing.new
    t2 = FourthThing.new
    assert t.save
    assert t2.save
    assert t.id != t2.id
  end
  
  def test_should_use_float_as_init_string
    assert Thing.calculate_init_string.match /(0-9)*\.(0-9)*/
  end
  
  def test_should_be_lower_than_256
    t = SecondThing.new
    assert t.save
    assert t.id < 16
  end
  
  def test_should_throw_error_when_out_of_ids
    assert_raise ActiveRecord::ActiveRecordError do
      17.times do |n|
        t = SecondThing.new
        t.save
      end
    end
  end
  
  def test_should_check_collisions_on_base_class
    assert_raise ActiveRecord::ActiveRecordError do
      9.times do
        juliet = Woman.new
        juliet.save
        romeo = Man.new
        romeo.save
      end
    end
  end
end
