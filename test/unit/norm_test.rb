require File.dirname(__FILE__) + '/../../test/test_helper'

class SecondThing < ActiveRecord::Base
  set_table_name "things"
  has_hashed_primary_key :hash_algorithm => lambda { |str| Digest::SHA1.hexdigest(str) }
end

class ThirdThing < ActiveRecord::Base
  set_table_name "things"
  has_hashed_primary_key :init_string => lambda { Time.now.to_f.to_s }
end

class NormTest < Test::Unit::TestCase
  def test_should_have_long_pk
    t = Thing.new
    t.save
    assert_equal Time.now.to_str, Thing.init_string
    assert_equal 32, t.id.length
  end
  
  # well,... how to test this without time dep
  def test_should_not_create_duplicates
    t = Thing.new
    t2 = Thing.new
    t.save
    t2.save
  end
  
  def test_should_use_sha1
    t = SecondThing.new
    t.save
    assert_equal 40, t.id.length 
  end
  
  def test_should_use_float_as_init_string
    assert ThirdThing.init_string.match /(0-9)*\.(0-9)*/
  end
end
