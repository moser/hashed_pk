require File.dirname(__FILE__) + '/../../test/test_helper'
class StiTest < Test::Unit::TestCase
  def setup
    StiParent.delete_all
  end
  
  def test_should_not_fail
    parent = StiParent.new
    c = StiChild.new
    assert c.save
  end
  
  def test_should_check_collisions_on_base_class
    assert_raise ActiveRecord::ActiveRecordError do
      9.times do
        parent = StiParent.new
        parent.save
        child = StiChild.new
        child.save
      end
    end
  end
end
