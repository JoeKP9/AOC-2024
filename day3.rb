File.open('day3.txt') do
  p _1.read.scan(Regexp.new('mul\(\d\d*\d*,\d\d*\d*\)')).map { |hit| hit.split(Regexp.union(['(', ')', ',']))[1].to_i * hit.split(Regexp.union(['(', ')', ',']))[2].to_i }.sum
end
