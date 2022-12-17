# https://adventofcode.com/2022/day/17

class Rock
  SHAPES = [
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
    [{0, 1}, {1, 0}, {1, 1}, {1, 2}, {2, 1}],
    [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}],
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
    [{0, 0}, {0, 1}, {1, 0}, {1, 1}],
  ]

  @shape : Array({Int32, Int32})
  @is_settled = false

  getter shape, is_settled

  def initialize(offset_y : Int32, shape_index : Int32)
    @shape = Rock::SHAPES[shape_index].map { |(sx, sy)| {sx + 2, sy + offset_y} }
  end

  def push(dir : Int32, rocks : Array(Rock))
    is_blocked = shape.any? do |(sx, sy)|
      break true if dir == -1 && sx == 0
      break true if dir == 1 && sx == 6
      rocks.any?(&.collides_y?({sx, sy}, dir))
    end

    @shape.map! { |(sx, sy)| {sx + dir, sy} } unless is_blocked
  end

  def fall(rocks : Array(Rock))
    @is_settled = @shape.any? do |(sx, sy)|
      break true if sy == 1
      rocks.any?(&.collides_x?({sx, sy}))
    end

    @shape.map! { |(sx, sy)| {sx, sy - 1} } unless @is_settled
  end

  def max_height
    shape.max_of { |(sx, sy)| sy }
  end

  protected def collides_x?(other_shape : {Int32, Int32}) : Bool
    @shape.any? do |(sx, sy)|
      other_shape[0] == sx && sy == other_shape[1] - 1
    end
  end

  protected def collides_y?(other_shape : {Int32, Int32}, dir : Int32) : Bool
    x, y = other_shape
    @shape.any? do |(sx, sy)|
      sy == y && (dir == -1 && sx == x - 1 || dir == 1 && sx == x + 1)
    end
  end
end

# Part 1
def get_tower_height(jet_pattern : String) : Int32
  push_directions = jet_pattern.chars.map { |c| c == '>' ? 1 : -1 }.each.cycle
  rocks = [] of Rock
  max_height = 0

  2022.times do |i|
    rock = Rock.new(max_height + 4, i % Rock::SHAPES.size)

    until rock.is_settled
      push_direction = push_directions.next.unsafe_as(Int32)
      rock.push(push_direction, rocks.last(50))
      rock.fall(rocks.last(50))
    end

    rocks << rock
    max_height = rock.max_height if rock.max_height > max_height
  end

  max_height
end

# Part 2
def get_huge_tower_height(jet_pattern : String) : Int64
  push_directions = jet_pattern.chars.map { |c| c == '>' ? 1 : -1 }.each.cycle
  rocks = [] of Rock
  increases = [0] of Int32
  max_height = 0

  4000.times do |i|
    rock = Rock.new(max_height + 4, i % Rock::SHAPES.size)

    until rock.is_settled
      push_direction = push_directions.next.unsafe_as(Int32)
      rock.push(push_direction, rocks.last(50))
      rock.fall(rocks.last(50))
    end

    rocks << rock

    if rock.max_height > max_height
      increases << rock.max_height - max_height
      max_height = rock.max_height
    else
      increases << 0
    end
  end

  repeat_capture = increases.join.match(/(\d{10,})(\1)/)

  raise "No repeating increases" unless repeat_capture

  repeat_index = repeat_capture.begin
  repeat_size = repeat_capture.[0].size
  repeat_times, remainder = (1_000_000_000_000 - repeat_index + 1).divmod(repeat_size)

  height_before_repeat = increases[...repeat_index].sum
  increase_per_repeat = increases[repeat_index, repeat_size].sum
  remaining_increase = increases[repeat_index, remainder].sum

  height_before_repeat.to_i64 + (repeat_times * increase_per_repeat) + remaining_increase
end

test_jest_pattern = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

raise "Part 1 failed" unless get_tower_height(test_jest_pattern) == 3068
raise "Part 2 failed" unless get_huge_tower_height(test_jest_pattern) == 1514285714288

if ARGV.size > 0
  input = ARGV[0]
  puts get_tower_height(input)
  puts get_huge_tower_height(input)
end
