require_relative "test_helper"

describe WeeklyHours do
  it "can parse single day with time" do
    expect(WeeklyHours::Parser.new.parse("Mon 10 am - 5 pm").tokenize).must_equal [[1], [10*3600, 17*3600]]
  end

  it "can parse single day with time containing minutes in start time" do
    expect(WeeklyHours::Parser.new.parse("Mon 10:10 am - 5 pm").tokenize).must_equal [[1], [10*3600+10*60, 17*3600]]
  end

  it "can parse single day with time containing minutes in end time" do
    expect(WeeklyHours::Parser.new.parse("Mon 10 am - 5:20 pm").tokenize).must_equal [[1], [10*3600, 17*3600+20*60]]
  end
end
