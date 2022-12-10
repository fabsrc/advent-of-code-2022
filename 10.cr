# https://adventofcode.com/2022/day/10

# Part 1
def get_sum_of_signal_strengths(instructions : String) : Int32
  x = 1
  cycle = 0
  sum = 0

  instructions.lines.each do |line|
    ins, *inc = line.split(' ')
    cycle_length = ins === "addx" ? 2 : 1

    cycle_length.times do |sc|
      cycle += 1

      if [20, 60, 100, 140, 180, 220].includes?(cycle)
        sum += x * cycle
      end

      x += inc.first.to_i if sc != 0
    end
  end

  sum
end

# Part 2
def get_crt_screen(instructions : String) : String
  x = 1
  cycle = 0
  screen = ""

  instructions.lines.each do |line|
    ins, *inc = line.split(' ')
    cycle_length = ins === "addx" ? 2 : 1

    cycle_length.times do |sc|
      pos = cycle % 40
      screen += "\n" if cycle > 0 && pos == 0
      screen += [pos, pos + 1, pos - 1].includes?(x) ? "#" : "."
      cycle += 1
      x += inc.first.to_i if sc != 0
    end
  end

  screen
end

test_instructions = <<-INPUT
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
INPUT

raise "Part 1 failed" unless get_sum_of_signal_strengths(test_instructions) == 13140
raise "Part 2 failed" unless get_crt_screen(test_instructions) == <<-SCREEN
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
SCREEN

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_signal_strengths(input)
  puts get_crt_screen(input)
end
