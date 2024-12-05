File.open('day5.txt') do
  data = _1.read.split("\n")
  data_by_line = data.map{ |line| line.split("\n")[0] }
  line_split = data_by_line.each_with_index.map {|line, i| i if line.nil? }.compact[0]
  pages = data_by_line[line_split + 1..].map{ |page| page.split(",").map{ |str| str.to_i } }
  rules = data_by_line[..line_split - 1].map{ |rule| rule.split("|") }
  rules = Hash[ rules.group_by{ |k| k[0].to_i }.map{ |key, val| [key,val.map{|item| item[1..-1]}.flatten.map{ |str| str.to_i }] } ]
  p rules
  p rules.size
  $bad_pages = []

  def check_pages(rules, pages)
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
            else
              $bad_pages.push([page, [page.index(rule_set[0]), "!<", page.index(rule)]])
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

  def check_bad_pages(rules, bad_pages)
    pages_passed = []
    bad_pages.map do |page|
      to_fix = Hash[ page[1].group_by{ |k| k[0] }.map{ |key, val| [key,val.map{|item| item[-1]}.min] } ]
      page = page[0].dup
      p "page: #{page} - to fix: #{to_fix}"
      to_fix.each do |fix|
        p page
        p "#{page[fix[0]]} < #{rules[page[fix[0]]]}"
        p fix
        changing_num = page[fix[0]]
        page.delete_at(fix[0])
        page.insert(fix[1], changing_num)
        p page
        check_pages(rules, [page])
        p "======================"
      end
    end
  end

  check_pages(rules, pages)
  p "=============="
  p pages
  p $bad_pages
  $bad_pages = Hash[ $bad_pages.group_by{ |k| k[0] }.map{ |key, val| [key,val.map{|item| item[1..-1]}.flatten(1)] } ]
  p $bad_pages
  check_bad_pages(rules, $bad_pages)
end
