# https://adventofcode.com/2022/day/14

def create_cave(scan : String) : {Hash({Int32, Int32}, Char), Int32}
  cave = Hash({Int32, Int32}, Char).new { '.' }

  scan.lines.each do |line|
    line.split(" -> ").map(&.split(',').map(&.to_i)).each_cons_pair do |(x1, y1), (x2, y2)|
      rx1, rx2 = [x1, x2].sort
      ry1, ry2 = [y1, y2].sort
      (ry1..ry2).each do |y|
        (rx1..rx2).each do |x|
          cave[{x, y}] = '#'
        end
      end
    end
  end

  {cave, cave.keys.max_of(&.[1])}
end

# Part 1
def get_settled_units_of_sand(scan : String) : Int32?
  cave, max_y = create_cave(scan)

  loop do
    sx = 500
    sy = 0

    loop do
      return cave.values.count('o') if sy > max_y

      if cave[{sx, sy + 1}] == '.'
        sy += 1
      elsif cave[{sx - 1, sy + 1}] == '.'
        sy += 1
        sx -= 1
      elsif cave[{sx + 1, sy + 1}] == '.'
        sy += 1
        sx += 1
      else
        cave[{sx, sy}] = 'o'
        break
      end
    end
  end
end

# Part 2
def get_settled_units_of_sand_with_ground(scan : String) : Int32?
  cave, max_y = create_cave(scan)

  loop do
    sx = 500
    sy = 0

    loop do
      return cave.values.count('o') if cave[{500, 0}] == 'o'

      if sy == max_y + 1
        cave[{sx, sy}] = 'o'
        break
      elsif cave[{sx, sy + 1}] == '.'
        sy += 1
      elsif cave[{sx - 1, sy + 1}] == '.'
        sx -= 1
        sy += 1
      elsif cave[{sx + 1, sy + 1}] == '.'
        sx += 1
        sy += 1
      else
        cave[{sx, sy}] = 'o'
        break
      end
    end
  end
end

test_scan = <<-INPUT
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
INPUT

raise "Part 1 failed" unless get_settled_units_of_sand(test_scan) == 24
raise "Part 2 failed" unless get_settled_units_of_sand_with_ground(test_scan) == 93

if ARGV.size > 0
  input = ARGV[0]
  puts get_settled_units_of_sand(input)
  puts get_settled_units_of_sand_with_ground(input)
end
