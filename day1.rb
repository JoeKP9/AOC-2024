File.open('day1.txt') do
  x = _1.read.split("\n").map { |a| a.split('   ') }
  r = [x.sort_by { |e| -e[0] }.map { |m| m[0] }, x.sort_by { |e| -e[1] }.map { |m| m[1] }]
  p("part 1: #{r[0].each_with_index.map { |e, i| (r[1][i].to_i - e.to_i).abs }.sum}")
  p("part 2: #{r[0].map { |e| (e.to_i * r[1].count(e).to_i) }.sum}")
end
