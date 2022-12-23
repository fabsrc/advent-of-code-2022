# https://adventofcode.com/2022/day/23

class Elf
  DIRECTIONS = {
    N: [{-1, -1}, {0, -1}, {1, -1}],
    S: [{-1, 1}, {0, 1}, {1, 1}],
    W: [{-1, -1}, {-1, 0}, {-1, 1}],
    E: [{1, -1}, {1, 0}, {1, 1}],
  }
  UNIQUE_DIRECTIONS = DIRECTIONS.values.to_a.flatten.uniq

  getter x, y, proposed_move

  def initialize(@x : Int32, @y : Int32)
  end

  def calculate_proposed_move(elves : Hash({Int32, Int32}, Elf), offset : Int32) : {Int32, Int32}?
    @proposed_move = nil

    return unless UNIQUE_DIRECTIONS.any? { |(dx, dy)| elves.has_key?({@x + dx, @y + dy}) }

    next_dir = DIRECTIONS.to_a.rotate(offset).find do |_, dirs|
      dirs.none? { |(dx, dy)| elves.has_key?({@x + dx, @y + dy}) }
    end

    return unless next_dir

    @proposed_move = case next_dir[0]
                     when :N
                       {@x + 0, @y - 1}
                     when :S
                       {@x + 0, @y + 1}
                     when :W
                       {@x - 1, @y + 0}
                     when :E
                       {@x + 1, @y - 0}
                     end
  end

  def move(elves : Hash({Int32, Int32}, Elf))
    if @proposed_move
      elves.delete({@x, @y})
      @x = @proposed_move.not_nil![0]
      @y = @proposed_move.not_nil![1]
      elves[{@x, @y}] = self
    end
  end
end

# Part 1
def get_empty_ground_count(scan : String) : Int32
  elves = scan.lines.each.with_index.flat_map do |line, y|
    line.chars.each.with_index.compact_map do |c, x|
      { {x, y}, Elf.new(x, y) } if c == '#'
    end
  end.to_h

  10.times do |round|
    elves.values.each(&.calculate_proposed_move(elves, round % 4))
    proposed_move_count = elves.values.tally_by(&.proposed_move)
    elves.values.select { |elf| proposed_move_count[elf.proposed_move] == 1 }.each(&.move(elves))
  end

  min_x, max_x = elves.values.minmax_of(&.x)
  min_y, max_y = elves.values.minmax_of(&.y)
  (min_x..max_x).size * (min_y..max_y).size - elves.size
end

# Part 2
def get_first_round_without_moves(scan : String) : Int32
  elves = scan.lines.each.with_index.flat_map do |line, y|
    line.chars.each.with_index.compact_map do |c, x|
      { {x, y}, Elf.new(x, y) } if c == '#'
    end
  end.to_h

  round = 0

  loop do
    proposed_move_count = Hash({Int32, Int32}, Int32).new { 0 }
    elves.values.each do |elf|
      proposed_move = elf.calculate_proposed_move(elves, round % 4)
      proposed_move_count[proposed_move] += 1 if proposed_move
    end
    moved_elves = elves.values.count do |elf|
      elf.move(elves) if elf.proposed_move && proposed_move_count[elf.proposed_move] == 1
    end
    round += 1
    break if moved_elves == 0
  end

  round
end

test_scan = <<-INPUT
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
INPUT

raise "Part 1 failed" unless get_empty_ground_count(test_scan) == 110
raise "Part 2 failed" unless get_first_round_without_moves(test_scan) == 20

if ARGV.size > 0
  input = ARGV[0]
  puts get_empty_ground_count(input)
  puts get_first_round_without_moves(input)
end
