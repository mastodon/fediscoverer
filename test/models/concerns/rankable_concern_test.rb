require "test_helper"

class RankableConcernTest < ActiveSupport::TestCase
  class Record
    include RankableConcern

    attr_reader :score

    def initialize(score) = @score = score
  end

  test "::rank returns a rank between 0 and 100" do
    records = [ 10, 7, 4, 1 ].map { |i| Record.new(i) }
    Record.rank(records)

    assert_equal [ 100, 70, 40, 10 ], records.map(&:rank)

    records = [ 1000, 768, 102, 1 ].map { |i| Record.new(i) }
    Record.rank(records)

    assert_equal [ 100, 77, 11, 1 ], records.map(&:rank)

    record = Record.new(1.5833333333333333)
    Record.rank([ record ])

    assert_equal 100, record.rank
  end
end
