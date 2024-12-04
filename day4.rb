File.open('day4.txt') do
  data = _1.read.split("\n")

  $complete_combos = []

  def colourize_match(match_location)
    match = $display_data[match_location[0]][match_location[1]]
    if $display_data[match_location[0]][match_location[1]].size == 1
      $display_data[match_location[0]][match_location[1]] = "\u001b[35m#{match}\u001b[0m"
    else
      match = match[5]
      $display_data[match_location[0]][match_location[1]] = "\x1b[96m#{match}\x1b[0m"
    end
  end

  def findNextTarget(data, location, combo, target, line_len, line_height, prev_direction, searched_directions, starting_location)
    target_word = ["X", "M", "A", "S"]
    left = location[1] > 0 ? [location[0], location[1] - 1] : "na"
    right = location[1] < line_len - 1 ? [location[0], location[1] + 1] : "na"
    up = location[0] > 0 ? [location[0] - 1, location[1]] : "na"
    down = location[0] < line_height - 1 ? [location[0] + 1, location[1]] : "na"
    d_u_l = up != "na" && left != "na" ? [location[0] - 1, location[1] - 1] : "na"
    d_u_r = up != "na" && right != "na" ? [location[0] - 1, location[1] + 1] : "na"
    d_d_l = down != "na" && left != "na" ? [location[0] + 1, location[1] - 1] : "na"
    d_d_r = down != "na" && right != "na" ? [location[0] + 1, location[1] + 1] : "na"
    # p "location: #{location}, left: #{left}, right: #{right}, up: #{up}, down: #{down}"
    location_array = [[left, "left"], [right, "right"], [up, "up"], [down, "down"],
                      [d_u_l, "dul"], [d_u_r, "dur"], [d_d_l, "ddl"], [d_d_r, "ddr"]]
    location_array.each do |searching_lo|
      # if searching direction == last searched direction
      next if !prev_direction.nil? && searching_lo[1] != prev_direction
      if searched_directions.include?(searching_lo[1])
        next 
      else
        # p "Searched directions: #{searched_directions} - Searching: #{searching_lo[1]}"
      end
      # if searching location exists and we havent already gotten a match for the target 
      # p "Combo size: #{combo.size} - Target index: #{target_word.index(target)} - Combo: #{combo}"
      if searching_lo[0] != "na" 
        # p "Last found target: #{combo[combo.size - 1][1]} - Searching for: #{target}"
        searched_letter = data[searching_lo[0][0]][searching_lo[0][1]]
        if searched_letter == target
          combo.push([searching_lo[0], target])
          if target == "S"
            $complete_combos.push(combo)
            # p "Found complete match: #{combo}"
            searched_directions = searched_directions.push(searching_lo[1])
            combo = [[starting_location, "X"]]
            # p "Looking again from: #{starting_location} - with searched directions: #{searched_directions} - Combo: #{combo} - 0"
            findNextTarget(data, starting_location, combo, "M", line_len, line_height, nil, searched_directions, starting_location)
          else
            next_target = target_word[combo.size]
            # p "Found: #{target} - In direction: #{searching_lo[1]} - Looking for: #{next_target} - From: #{searching_lo[0]}"
            findNextTarget(data, searching_lo[0], combo, next_target, line_len, line_height, searching_lo[1], searched_directions, starting_location)
          end
        else
          searched_directions = searched_directions.push(searching_lo[1])
          # p "Looked for: #{target} - in direction: #{searching_lo[1]} - found #{searched_letter} - 1"
          combo = [[starting_location, "X"]]
          # p "Looking again from: #{starting_location} - with searched directions: #{searched_directions} - Combo: #{combo}"
          findNextTarget(data, starting_location, combo, "M", line_len, line_height, nil, searched_directions, starting_location)
        end
      else
        searched_directions = searched_directions.push(searching_lo[1])
        # p "Looked for: #{target} - in direction: #{searching_lo[1]} - at #{searching_lo[0]} - found #{searched_letter} - 2"
        combo = [[starting_location, "X"]]
        # p "Looking again from: #{starting_location} - with searched directions: #{searched_directions} - Combo #{combo}"
        findNextTarget(data, starting_location, combo, "M", line_len, line_height, nil, searched_directions, starting_location)
      end
    end
  end

  # splitting the data for searching by line and char
  used_data = data.map{|lines| lines.split("")}
  $display_data = data.map{|lines| lines.split("")}

  data.each_with_index do |line, line_no|
    line.split("").each_with_index do |letter, letter_no|
      # searching for X
      if letter == "X"
        combo = [[[line_no, letter_no], "X"]]
        # p "found X: #{[line_no, letter_no]}"
        findNextTarget(used_data, [line_no, letter_no], combo, "M", line.size, data.size, nil, [], [line_no, letter_no])
      end
    end
  end

  # p "Combos: #{$complete_combos}, Count: #{$complete_combos.size}"
  $complete_combos.map{|combo_list| combo_list.map{|combo_item| colourize_match(combo_item[0]) }}
  $display_data.map{|line| puts line.join() }
  p "Count: #{$complete_combos.size}"
end
