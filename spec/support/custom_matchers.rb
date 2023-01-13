require "rspec/expectations"

RSpec::Matchers.define :match_closely do |expected|
  expected.flatten.each.with_index do |coord, index|
    match do |actual|
      (coord - actual.flatten[index]).abs < 0.00000001
    end
  end
  failure_message do |actual|
    "expected that #{actual} would be close to #{expected}"
  end
end
