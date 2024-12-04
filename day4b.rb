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
    target_word = ["M", "S"]
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

    diag_up_left_val = data[d_u_l[0]][d_u_l[1]] if d_u_l != "na"
    diag_up_right_val = data[d_u_r[0]][d_u_r[1]] if d_u_r != "na"
    diag_down_left_val = data[d_d_l[0]][d_d_l[1]] if d_d_l != "na"
    diag_down_right_val = data[d_d_r[0]][d_d_r[1]] if d_d_r != "na"

    vals = [diag_up_left_val, diag_down_right_val, diag_up_right_val, diag_down_left_val].compact

    if vals.size == 4 
      # p  "diag up left: #{diag_up_left_val}" 
      # p  "diag up right: #{diag_up_right_val}" 
      # p  "diag down left: #{diag_down_left_val}" 
      # p  "diag down right: #{diag_down_right_val}"
      # p  "==========================="
      # \
      if diag_up_left_val == "M" && diag_down_right_val == "S" || diag_up_left_val == "S" && diag_down_right_val == "M"
        # /
        if diag_up_right_val == "M" && diag_down_left_val == "S" || diag_up_right_val == "S" && diag_down_left_val == "M"
          # p([location, d_u_l, d_u_r, d_d_l, d_d_r])
          $complete_combos.push([location, d_u_l, d_u_r, d_d_l, d_d_r])
        end
      end
    end
  end

  # splitting the data for searching by line and char
  used_data = data.map{|lines| lines.split("")}
  $display_data = data.map{|lines| lines.split("")}

  data.each_with_index do |line, line_no|
    line.split("").each_with_index do |letter, letter_no|
      # searching for X
      if letter == "A"
        combo = [[[line_no, letter_no], "A"]]
        # p "found X: #{[line_no, letter_no]}"
        findNextTarget(used_data, [line_no, letter_no], combo, ["M", "S"], line.size, data.size, nil, [], [line_no, letter_no])
      end
    end
  end

  $complete_combos.map{|combo_list| combo_list.map{|combo_item_location| colourize_match(combo_item_location) }}
  $display_data.map{|line| puts line.join() }
  p "Count: #{$complete_combos.size}"
end
