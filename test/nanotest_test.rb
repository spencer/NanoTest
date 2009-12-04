require 'lib/nano_test'
include NanoTest

class NanoTestTest < NanoTest::TestCase
  def test_is_equal_true
    assert_equal(1, 1)
  end
  
  def test_is_equal_flase
    #should fail
    assert_equal(1, 2, '1 and 2 are not equal')
  end
  
  def test_not_equal_true
    assert_not_equal(1, 2)
  end
  
  def test_this_not_equal_false
    #should fail
    assert_not_equal(1, 1, '1 and 1 are equal')
  end
end

NanoTest::Runner.run_tests