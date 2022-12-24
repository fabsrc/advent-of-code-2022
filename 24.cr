# https://adventofcode.com/2022/day/24

DIRECTIONS = {
  'x' => {0, 0},
  '^' => {0, -1},
  '>' => {1, 0},
  'v' => {0, 1},
  '<' => {-1, 0},
}

record Blizzard, x : Int32, y : Int32, dir : {Int32, Int32}, max_x : Int32, max_y : Int32 do
  def get_position_at(minutes : Int32) : {Int32, Int32}
    {(x + (dir[0] * minutes)) % (max_x + 1), (y + (dir[1] * minutes)) % (max_y + 1)}
  end
end

def get_blizzards_and_max_values(map : String) : {Array(Blizzard), Int32, Int32}
  max_x = map.lines.first[1..-2].size - 1
  max_y = map.lines[1..-2].size - 1

  blizzards = map.lines[1..-2].each.with_index.flat_map do |line, y|
    line.chars[1..-2].each.with_index.compact_map do |c, x|
      Blizzard.new(x, y, DIRECTIONS[c], max_x, max_y) unless c == '.'
    end
  end.to_a

  {blizzards, max_x, max_y}
end

# Part 1
def get_fewest_minutes_to_goal(map : String) : Int32
  blizzards, max_x, max_y = get_blizzards_and_max_values(map)
  start = {0, -1}
  goal = {max_x, max_y + 1}
  blizzard_positions = Hash(Int32, Set({Int32, Int32})).new
  queue = Deque.new([{start, 0}])

  until queue.empty?
    last_pos, last_minute = queue.shift
    last_x, last_y = last_pos

    next_minute = last_minute + 1
    blizzard_positions[next_minute] ||= blizzards.map(&.get_position_at(next_minute)).to_set

    DIRECTIONS.values.each do |dir|
      next_x = last_x + dir[0]
      next_y = last_y + dir[1]

      return next_minute if {next_x, next_y} == goal

      if next_x <= max_x && next_x >= 0 && next_y <= max_y && next_y >= 0 && !blizzard_positions[next_minute].includes?({next_x, next_y})
        queue << { {next_x, next_y}, next_minute } unless queue.includes?({ {next_x, next_y}, next_minute })
      end
    end

    queue << {last_pos, next_minute} if queue.empty?
  end

  raise "No result"
end

# Part 2
def get_fewest_minutes_to_goal_with_roundtrip(map : String) : Int32
  blizzards, max_x, max_y = get_blizzards_and_max_values(map)
  start = {0, -1}
  goal = {max_x, max_y + 1}
  blizzard_positions = Hash(Int32, Set({Int32, Int32})).new
  queue = Deque.new([{start, 0}])
  trip = 0

  until queue.empty?
    last_pos, last_minute = queue.shift
    last_x, last_y = last_pos

    next_minute = last_minute + 1
    blizzard_positions[next_minute] ||= blizzards.map(&.get_position_at(next_minute)).to_set

    DIRECTIONS.values.each do |dir|
      next_x = last_x + dir[0]
      next_y = last_y + dir[1]

      if {next_x, next_y} == goal && trip == 0
        queue.clear << {goal, next_minute}
        trip += 1
        break
      elsif {next_x, next_y} == start && trip == 1
        queue.clear << {start, next_minute}
        trip += 1
        break
      elsif {next_x, next_y} == goal && trip == 2
        return next_minute
      end

      if next_x <= max_x && next_x >= 0 && next_y <= max_y && next_y >= 0 && !blizzard_positions[next_minute].includes?({next_x, next_y})
        queue << { {next_x, next_y}, next_minute } unless queue.includes?({ {next_x, next_y}, next_minute })
      end
    end

    queue << {last_pos, next_minute} if queue.empty?
  end

  raise "No result"
end

test_map = <<-INPUT
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
INPUT

raise "Part 1 failed" unless get_fewest_minutes_to_goal(test_map) == 18
raise "Part 2 failed" unless get_fewest_minutes_to_goal_with_roundtrip(test_map) == 54

if ARGV.size > 0
  input = ARGV[0]
  puts get_fewest_minutes_to_goal(input)
  puts get_fewest_minutes_to_goal_with_roundtrip(input)
end
