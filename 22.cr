# https://adventofcode.com/2022/day/22
# TODO: General solution

DIRECTIONS = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

# Part 1
def get_final_password(notes : String) : Int32
  board_input, path = notes.split("\n\n")
  board = Hash({Int32, Int32}, Char).new

  board_input.lines.each_with_index(1) do |line, y|
    line.chars.each_with_index(1) do |c, x|
      board[{x, y}] = c unless c.whitespace?
    end
  end

  pos = board.keys.select { |x, y| y == 1 }.min
  dir = 0

  path.scan(/\d+|[RL]/).each do |m|
    if m[0] =~ /\d+/
      steps = m[0].to_i
      direction = DIRECTIONS[dir]

      steps.times do
        next_pos = {pos[0] + direction[0], pos[1] + direction[1]}

        unless board.has_key?(next_pos)
          next_pos = case dir
                     when 0
                       board.keys.select { |(x, y)| y == pos[1] }.min_by { |(x, y)| x }
                     when 1
                       board.keys.select { |(x, y)| x == pos[0] }.min_by { |(x, y)| y }
                     when 2
                       board.keys.select { |(x, y)| y == pos[1] }.max_by { |(x, y)| x }
                     when 3
                       board.keys.select { |(x, y)| x == pos[0] }.max_by { |(x, y)| y }
                     else
                       pos
                     end
        end

        pos = next_pos unless board[next_pos]? == '#'
      end
    elsif m[0] == "R"
      dir = (dir + 1) % 4
    elsif m[0] == "L"
      dir = (dir - 1) % 4
    end
  end

  1000 * pos[1] + 4 * pos[0] + dir
end

# Part 2
def get_final_password_for_cube(notes : String, size : Int32) : Int32
  board_input, path = notes.split("\n\n")
  board = Hash({Int32, Int32, Int32}, Char).new
  cube_mapping = Hash({Int32, Int32, Int32}, {Int32, Int32}).new

  side_count = Hash({Int32, Int32}, Int32).new { 0 }
  current = {0, 0}

  board_input.lines.each_with_index(1) do |line, y|
    current = {current[0], (current[1] % size) + 1}

    line.chars.each_with_index(1) do |c, x|
      unless c.whitespace?
        current = {(current[0] % size) + 1, current[1]}
        side_count[current] += 1
        coord = {side_count[current], current[0], current[1]}
        board[coord] = c
        cube_mapping[coord] = {x, y}
      end
    end
  end

  pos = {1, 1, 1}
  dir = 0

  path.scan(/\d+|[RL]/).each do |m|
    if m[0] =~ /\d+/
      steps = m[0].to_i

      steps.times do
        direction = DIRECTIONS[dir]
        next_pos = {pos[0], pos[1] + direction[0], pos[2] + direction[1]}
        next_dir = dir

        unless board.has_key?(next_pos)
          case dir
          when 0
            case pos[0]
            when 1
              next_pos = {2, 1, pos[2]}
              next_dir = 0
            when 2
              next_pos = {5, size, (size + 1) - pos[2]}
              next_dir = 2
            when 3
              next_pos = {2, pos[2], size}
              next_dir = 3
            when 4
              next_pos = {5, 1, pos[2]}
              next_dir = 0
            when 5
              next_pos = {2, size, (size + 1) - pos[2]}
              next_dir = 2
            when 6
              next_pos = {5, pos[2], size}
              next_dir = 3
            end
          when 1
            case pos[0]
            when 1
              next_pos = {3, pos[1], 1}
              next_dir = 1
            when 2
              next_pos = {3, size, pos[1]}
              next_dir = 2
            when 3
              next_pos = {5, pos[1], 1}
              next_dir = 1
            when 4
              next_pos = {6, pos[1], 1}
              next_dir = 1
            when 5
              next_pos = {6, size, pos[1]}
              next_dir = 2
            when 6
              next_pos = {2, pos[1], 1}
              next_dir = 1
            end
          when 2
            case pos[0]
            when 1
              next_pos = {4, 1, (size + 1) - pos[2]}
              next_dir = 0
            when 2
              next_pos = {1, size, pos[2]}
              next_dir = 2
            when 3
              next_pos = {4, pos[2], 1}
              next_dir = 1
            when 4
              next_pos = {1, 1, (size + 1) - pos[2]}
              next_dir = 0
            when 5
              next_pos = {4, size, pos[2]}
              next_dir = 2
            when 6
              next_pos = {1, pos[2], 1}
              next_dir = 1
            end
          when 3
            case pos[0]
            when 1
              next_pos = {6, 1, pos[1]}
              next_dir = 0
            when 2
              next_pos = {6, pos[1], size}
              next_dir = 3
            when 3
              next_pos = {1, pos[1], size}
              next_dir = 3
            when 4
              next_pos = {3, 1, pos[1]}
              next_dir = 0
            when 5
              next_pos = {3, pos[1], size}
              next_dir = 3
            when 6
              next_pos = {4, pos[1], size}
              next_dir = 3
            end
          end
        end

        unless board[next_pos]? == '#'
          pos = next_pos
          dir = next_dir
        end
      end
    elsif m[0] == "R"
      dir = (dir + 1) % 4
    elsif m[0] == "L"
      dir = (dir - 1) % 4
    end
  end

  mapped_pos = cube_mapping[pos]
  1000 * mapped_pos[1] + 4 * mapped_pos[0] + dir
end

test_notes = <<-INPUT
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
INPUT

raise "Part 1 failed" unless get_final_password(test_notes) == 6032
# raise "Part 2 failed" unless get_final_password_for_cube(test_notes, 4) == 5031

if ARGV.size > 0
  input = ARGV[0]
  puts get_final_password(input)
  puts get_final_password_for_cube(input, 50)
end
