# https://adventofcode.com/2022/day/3

# Part 1
def get_priority_sum_for_compartments(rucksacks : Array(String)) : Int32
  rucksacks.sum do |rucksack|
    comp_1, comp_2 = rucksack.chars.each_slice(rucksack.size // 2).to_a.map(&.to_set)
    common = (comp_1 & comp_2).first
    common.uppercase? ? common.ord - 38 : common.ord - 96
  end
end

# Part 2
def get_priority_sum_for_elves(rucksacks : Array(String)) : Int32
  rucksacks.in_groups_of(3, "").sum do |group|
    elf_1, elf_2, elf_3 = group.map(&.chars.to_set)
    common = (elf_1 & elf_2 & elf_3).first
    common.uppercase? ? common.ord - 38 : common.ord - 96
  end
end

test_rucksacks = [
  "vJrwpWtwJgWrhcsFMMfFFhFp",
  "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
  "PmmdzqPrVvPwwTWBwg",
  "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
  "ttgJtRGJQctTZtZT",
  "CrZsJsPPZsGzwwsLwLmpwMDw",
]
raise "Part 1 failed" unless get_priority_sum_for_compartments(test_rucksacks) === 157
raise "Part 2 failed" unless get_priority_sum_for_elves(test_rucksacks) === 70

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_priority_sum_for_compartments(input)
  puts get_priority_sum_for_elves(input)
end
