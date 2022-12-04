# https://adventofcode.com/2022/day/4

# Part 1
def get_number_of_containing_pairs(pairs : Array(String)) : Int32
  pairs.count do |pair|
    set_1, set_2 = pair
      .split(',')
      .map(&.split('-').map(&.to_i))
      .map { |(s, e)| (s..e).to_set }
    set_1.subset_of?(set_2) || set_1.superset_of?(set_2)
  end
end

# Part 2
def get_number_of_overlapping_pairs(pairs : Array(String)) : Int32
  pairs.count do |pair|
    set_1, set_2 = pair
      .split(',')
      .map(&.split('-').map(&.to_i))
      .map { |(s, e)| (s..e).to_set }
    set_1.intersects?(set_2)
  end
end

test_pairs = [
  "2-4,6-8",
  "2-3,4-5",
  "5-7,7-9",
  "2-8,3-7",
  "6-6,4-6",
  "2-6,4-8",
]
raise "Part 1 failed" unless get_number_of_containing_pairs(test_pairs) === 2
raise "Part 2 failed" unless get_number_of_overlapping_pairs(test_pairs) === 4

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_number_of_containing_pairs(input)
  puts get_number_of_overlapping_pairs(input)
end
