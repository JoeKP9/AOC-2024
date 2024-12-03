File.open('day2.txt') do
  # split by line
  linedatas = _1.read.split("\n")
  diffs = []
  # each line split by spaces
  lined = []
  linedatas.each do |line|
    linearry = line.split(' ')
    lined.push(linearry)
    # calculate diffs
    diffs.push(linearry[0..linearry.size - 2].each_with_index.map { |result, i| result.to_i - linearry[i + 1].to_i })
  end

  wrongens = []
  goodens = []

  diffs = diffs.each_with_index.map do |dif, i|
    if dif.all?(&:negative?) || dif.all?(&:positive?)
      # remove all negative numbers in tmp dif
      tmpdif = dif.dup.map { |d| d.abs }
      # If tmp diff numbers within range
      if tmpdif.max <= 3 && tmpdif.min != 0
        goodens.push(tmpdif)
      else
        # push index of line data (lined)
        wrongens.push(i)
      end
    else
      wrongens.push(i)
    end
  end.compact!

  semigood = []

  wrongens.map do |index|
    # get linedata from lined index in wrongens
    wrong = lined[index]
    fixed = false
    wrong.each_with_index do |_, i|
      # stop duplicates with more than one solution
      next if fixed

      # go through all numbers in line data to check problem dampner
      tmp = wrong.dup
      t = tmp.delete_at(i)
      # caluclate diffs from problem dampened line data
      diffs = tmp[0..tmp.size - 2].each_with_index.map do |result, i|
        result.to_i - tmp[i + 1].to_i
      end
      next unless diffs.all?(&:negative?) || diffs.all?(&:positive?)

      # turn diffs positive
      diffs = diffs.map { |d| d.abs }
      # If tmp diff numbers within range
      next unless diffs.max <= 3 && diffs.min != 0

      semigood.push([wrong, "remove #{t}"])
      fixed = true
      next
    end
  end

  p(goodens.size + semigood.size)
end
