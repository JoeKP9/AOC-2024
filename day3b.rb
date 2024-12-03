File.open('day3.txt') do
  data = _1.read
  e = data.scan(Regexp.new('mul\(\d+,\d+\)')).map do |hit|
    matchednums = hit.split(Regexp.union(['(', ')', ',']))
    index_of_do = data[0..data.index(hit)].dup.reverse.index("do()".reverse)
    index_of_dont = data[0..data.index(hit)].dup.reverse.index("don't()".reverse)
    matchednums[1].to_i * matchednums[2].to_i if index_of_dont.nil? && index_of_do.nil? || !index_of_do.nil? && index_of_dont.nil? || !index_of_dont.nil? && !index_of_do.nil? && index_of_do < index_of_dont
  end
  p e.compact.sum
end
