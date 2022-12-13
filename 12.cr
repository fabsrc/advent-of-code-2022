# https://adventofcode.com/2022/day/12

DIRECTION_VECTORS = [{0, -1}, {-1, 0}, {0, 1}, {1, 0}]

def count_steps(
  start : {Int32, Int32},
  dest_proc : {Int32, Int32} -> Bool,
  &neighbor_block : {Int32, Int32} -> Array({Int32, Int32})
) : Int32?
  open_squares = [start]
  steps = Hash({Int32, Int32}, Float32).new { Float32::INFINITY }
  steps[start] = 0

  while current = open_squares.sort_by! { |s| steps[s] }.shift
    return steps[current].to_i if dest_proc.call(current)

    neighbor_block.call(current).each do |neighbor|
      next_steps = steps[current] + 1
      if next_steps < steps[neighbor]
        steps[neighbor] = next_steps
        open_squares.push(neighbor) unless open_squares.includes?(neighbor)
      end
    end
  end
end

# Part 1
def get_fewest_steps(heightmap : String) : Int32?
  map = Hash({Int32, Int32}, Char).new
  start = {0, 0}
  dest = {0, 0}

  heightmap.lines.each.with_index do |line, y|
    line.chars.each.with_index do |col, x|
      map[{x, y}] = case col
                    when 'S'
                      start = {x, y}
                      'a'
                    when 'E'
                      dest = {x, y}
                      'z'
                    else
                      col
                    end
    end
  end

  dest_proc = ->(current : {Int32, Int32}) { current == dest }
  count_steps(start, dest_proc) do |current|
    DIRECTION_VECTORS.compact_map do |(cx, cy)|
      neighbor = {current[0] + cx, current[1] + cy}
      neighbor if map[neighbor]? && (map[current] >= map[neighbor] || map[current] + 1 == map[neighbor])
    end
  end
end

# Part 2
def get_fewest_steps_from_any_start(heightmap : String) : Int32?
  map = Hash({Int32, Int32}, Char).new
  dest = {0, 0}

  heightmap.lines.each.with_index do |line, y|
    line.chars.each.with_index do |col, x|
      map[{x, y}] = case col
                    when 'S'
                      'a'
                    when 'E'
                      dest = {x, y}
                      'z'
                    else
                      col
                    end
    end
  end

  dest_proc = ->(current : {Int32, Int32}) { map[current] == 'a' }
  count_steps(dest, dest_proc) do |current|
    DIRECTION_VECTORS.compact_map do |(cx, cy)|
      neighbor = {current[0] + cx, current[1] + cy}
      neighbor if map[neighbor]? && (map[current] <= map[neighbor] || map[current] - 1 == map[neighbor])
    end
  end
end

test_heightmap = <<-INPUT
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
INPUT

raise "Part 1 failed" unless get_fewest_steps(test_heightmap) == 31
raise "Part 2 failed" unless get_fewest_steps_from_any_start(test_heightmap) == 29

if ARGV.size > 0
  input = ARGV[0]
  puts get_fewest_steps(input)
  puts get_fewest_steps_from_any_start(input)
end
