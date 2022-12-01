# https://adventofcode.com/2022/day/1

# Part 1
def get_total_calories_of_top_elf(elf_calories : Array(Array(Int32))) : Int32
  elf_calories.map(&.sum).max
end

# Part 2
def get_total_calories_of_top_three_elfs(elf_calories : Array(Array(Int32))) : Int32
  elf_calories.map(&.sum).sort.last(3).sum
end

test_elf_calories = [
  [1000, 2000, 3000],
  [4000],
  [5000, 6000],
  [7000, 8000, 9000],
  [10000],
]
raise "Part 1 failed" unless get_total_calories_of_top_elf(test_elf_calories) === 24000
raise "Part 2 failed" unless get_total_calories_of_top_three_elfs(test_elf_calories) === 45000

if ARGV.size > 0
  input = ARGV[0].split("\n\n").map(&.split("\n").map(&.to_i))
  puts get_total_calories_of_top_elf(input)
  puts get_total_calories_of_top_three_elfs(input)
end
