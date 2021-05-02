require "time"
require "treetop"
Treetop.load(File.expand_path("weekly-hours", File.dirname(__FILE__)))

module WeeklyHours
  class Parser < Treetop::Runtime::CompiledParser
    include WeeklyHours

    def call(string)
      if result = parse(string)
        result.tokenize
      else
        raise Exception, self.failure_reason
      end
    end
  end

  class Availability < Treetop::Runtime::SyntaxNode
    def tokenize
      [
        days.tokenize,
        hours.tokenize,
      ]
    end
  end

  class Days < Treetop::Runtime::SyntaxNode
    def tokenize
      result = []

      i = init.tokenize

      m = middle.elements.map(&:tokenize)

      y = [Term].include?(term.class) ? term.tokenize : nil

      if y
        if m.empty?
          x = i
        else
          x = m.pop
          result.push(i)
          result += m
        end

        if y > x
          r = (x..y).to_a
        elsif x > y
          r = (0..y).to_a + (x..6).to_a
        else
          r = (x..y).to_a
        end
        result += r
      else
        result.push(i)
        result += m
      end

      range.elements.map(&:tokenize).map { |r| result += r }

      result += list.elements.map(&:tokenize)

      return result.uniq.sort
    end
  end

  class Term < Treetop::Runtime::SyntaxNode
    def tokenize
      day.tokenize
    end
  end

  class Range < Treetop::Runtime::SyntaxNode
    def tokenize
      x = init.tokenize
      y = term.tokenize

      if y > x
        r = (x..y).to_a
      elsif x > y
        r = (0..y).to_a + (x..6).to_a
      else
        r = (x..y).to_a
      end

      r
    end
  end

  class List < Treetop::Runtime::SyntaxNode
    def tokenize
      day.tokenize
    end
  end

  class Hours < Treetop::Runtime::SyntaxNode
    def tokenize
      [
        head.tokenize,
        tail.tokenize,
      ]
    end
  end

  class Time < Treetop::Runtime::SyntaxNode
    def tokenize
      if number.text_value =~ /\d+:\d+/
        return DateTime.strptime("1970/01/01 #{number.text_value} #{period.text_value}", '%Y/%m/%d %I:%M %P').to_time.to_i
      else
        return DateTime.strptime("1970/01/01 #{number.text_value} #{period.text_value}", '%Y/%m/%d %I %P').to_time.to_i
      end
    end
  end

  class Day < Treetop::Runtime::SyntaxNode
    def tokenize
      {
        "Sunday"      => 0,
        "Sun"         => 0,
        "Monday"      => 1,
        "Mon"         => 1,
        "Tuesday"     => 2,
        "Tues"        => 2,
        "Wednesday"   => 3,
        "Weds"        => 3,
        "Wed"         => 3,
        "Thursday"    => 4,
        "Thurs"       => 4,
        "Thu"         => 4,
        "Friday"      => 5,
        "Fri"         => 5,
        "Saturday"    => 6,
        "Satur"       => 6,
        "Sat"         => 6,
      }[text_value]
    end
  end
end
