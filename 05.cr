# https://adventofcode.com/2022/day/5

# Part 1: with_order = false
# Part 2: with_order = true
def get_crates_on_top(stack_input : String, with_order = false) : String
  starting_stacks, procedure = stack_input.split("\n\n")
  stacks = Array(Array(Char)).new

  starting_stacks.lines[..-1].each do |line|
    line.scan(/\[([A-Z])\]|(    )/).each.with_index do |match, stack_no|
      crate = match.captures.try &.first.try &.chars.first
      stacks.push([] of Char) if stacks.size <= stack_no
      stacks[stack_no] << crate if crate
    end
  end

  procedure.lines.each do |line|
    match = line.match(/move (\d+) from (\d+) to (\d+)/)
    amount, from, to = match.try &.captures.map(&.try &.to_i) || [] of Int32

    raise "Parsing error" unless from && to && amount

    crates = stacks[from - 1].shift(amount)
    crates.reverse! if with_order
    crates.each do |crate|
      stacks[to - 1].unshift(crate)
    end
  end

  stacks.map(&.first).join
end

test_stack_input = <<-STACKS
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
STACKS

raise "Part 1 failed" unless get_crates_on_top(test_stack_input) === "CMZ"
raise "Part 2 failed" unless get_crates_on_top(test_stack_input, true) === "MCD"

if ARGV.size > 0
  input = ARGV[0]
  puts get_crates_on_top(input)
  puts get_crates_on_top(input, true)
end
