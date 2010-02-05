require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib nanotest]))
include NanoTest

class NanoTestTest < NanoTest::TestCase
  def test_is_equal
    assert_equal(1, 1)
  end
  
  def test_is_not_equal
    #should fail
    assert_equal(1, 2, '1 and 2 are not equal - SHOULD FAIL!')
  end
  
  def test_not_equal_true
    assert_not_equal(1, 2)
  end
  
  def test_this_not_equal_false
    #should fail
    assert_not_equal(1, 1, '1 and 1 are equal - SHOULD FAIL!')
  end

  def test_this_matches
    assert_match(/A string/, "A string")
  end
end

NanoTest::Runner.run_tests
