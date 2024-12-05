File.open('day5.txt') do
  data = _1.read.split("\n")
  data_by_line = data.map{ |line| line.split("\n")[0] }
  line_split = data_by_line.each_with_index.map {|line, i| i if line.nil? }.compact[0]
  pages = data_by_line[line_split + 1..].map{ |page| page.split(",").map{ |str| str.to_i } }
  rules = data_by_line[..line_split - 1].map{ |rule| rule.split("|") }
  rules = Hash[ rules.group_by{ |k| k[0].to_i }.map{ |key, val| [key,val.map{|item| item[1..-1]}.flatten.map{ |str| str.to_i }] } ]
  p rules
  p rules.size
  pages_passed = []
  pages.map do |page|
    p page
    rule_sets_passed = []
    rules.map do |rule_set|
      next if pages_passed.include?(page)

      unless page.include?(rule_set[0])
        p(" #{rule_set[0]} not in page")
        rule_sets_passed.push(rule_set[1])
        p(" rule sets passed: #{rule_sets_passed.size} / #{rules.size}")
        next
      end

      rules_passed = []
      p " checking: #{rule_set[0]} < #{rule_set[1]}"
      rule_set[1].map do |rule|
        if page.include?(rule)
          if page.index(rule_set[0]) < page.index(rule)
            p " #{page.index(rule_set[0])} < #{page.index(rule)}"
            rules_passed.push(rule)
          end
        else
          p " #{rule} not included - passing"
          rules_passed.push(rule)
        end
      end
      p " Rules passed: #{rules_passed.size} / #{rule_set[1].size}"
      if rules_passed.size == rule_set[1].size
        rule_sets_passed.push(rule_set[1])
        p " rule sets passed: #{rule_sets_passed.size} / #{rules.size}"
      end
    end
    if rule_sets_passed.size == rules.size
      p " passed: #{rule_sets_passed.size} == #{rules.size}"
      pages_passed.push(page[page.size/2])
    end
  end
  p "pages passed middle page: #{pages_passed} - sum: #{pages_passed.sum}"
end
