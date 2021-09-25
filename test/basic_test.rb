require_relative "test_helper"

describe WeeklyHours do
  it "it can parse single day with time" do
    expect(WeeklyHours::Parser.new.parse("Mon 10 am - 5 pm").tokenize).must_equal [[1], [10*3600, 17*3600]]
  end
end
