require 'minitest/autorun'
require_relative 'bubble_sort'

class BubbleSortTest < Minitest::Test
  def test_bubble_sort
    assert_equal [2, 3, 4, 5, 8, 10, 11, 18, 20, 33], bubble_sort([10, 8, 3, 5, 2, 4, 11, 18, 20, 33])
  end
end