# https://adventofcode.com/2022/day/9

class Knot
  property x, y

  def initialize(@x : Int32, @y : Int32)
  end

  def move(vector : {Int32, Int32})
    @x += vector[0]
    @y += vector[1]
  end

  def follow(other : Knot)
    dx = other.x - self.x
    dy = other.y - self.y

    if dx.abs == 2 || dy.abs == 2
      @x += dx.sign
      @y += dy.sign
    end
  end

  def pos
    {@x, @y}
  end
end

# Part 1: no_of_knots = 2
# Part 2: no_of_knots = 10
def get_tail_position_count(motions : String, no_of_knots : Number) : Int32
  direction_vectors = {U: {0, 1}, R: {1, 0}, D: {0, -1}, L: {-1, 0}}
  knots = Array(Knot).new(no_of_knots) { Knot.new(0, 0) }
  visited_tail_positions = Set({Int32, Int32}).new

  motions.lines.each do |line|
    direction, steps = line.split(' ')
    vector = direction_vectors[direction]

    steps.to_i.times do
      knots.first.move(vector)

      knots.each_cons_pair do |prev_knot, knot|
        knot.follow(prev_knot)
      end

      visited_tail_positions.add(knots.last.pos)
    end
  end

  visited_tail_positions.size
end

test_motions = <<-INPUT
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
INPUT
test_motions_2 = <<-INPUT
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
INPUT

raise "Part 1 failed" unless get_tail_position_count(test_motions, 2) == 13
raise "Part 2 failed" unless get_tail_position_count(test_motions, 10) == 1
raise "Part 2 failed" unless get_tail_position_count(test_motions_2, 10) == 36

if ARGV.size > 0
  input = ARGV[0]
  puts get_tail_position_count(input, 2)
  puts get_tail_position_count(input, 10)
end
