# https://adventofcode.com/2022/day/6

# Part 1: no_of_chars = 4
# Part 2: no_of_chars = 14
def get_index_of_marker(datastream : String, no_of_chars : Int32) : Int32
  no_of_chars + datastream.chars.each_cons(no_of_chars, true).index!(&.uniq.size.== no_of_chars)
end

test_datastream_1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
test_datastream_2 = "bvwbjplbgvbhsrlpgdmjqwftvncz"
test_datastream_3 = "nppdvjthqldpwncqszvftbrmjlhg"
test_datastream_4 = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
test_datastream_5 = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

raise "Part 1 failed" unless get_index_of_marker(test_datastream_1, 4) == 7
raise "Part 1 failed" unless get_index_of_marker(test_datastream_2, 4) == 5
raise "Part 1 failed" unless get_index_of_marker(test_datastream_3, 4) == 6
raise "Part 1 failed" unless get_index_of_marker(test_datastream_4, 4) == 10
raise "Part 1 failed" unless get_index_of_marker(test_datastream_5, 4) == 11

raise "Part 2 failed" unless get_index_of_marker(test_datastream_1, 14) == 19
raise "Part 2 failed" unless get_index_of_marker(test_datastream_2, 14) == 23
raise "Part 2 failed" unless get_index_of_marker(test_datastream_3, 14) == 23
raise "Part 2 failed" unless get_index_of_marker(test_datastream_4, 14) == 29
raise "Part 2 failed" unless get_index_of_marker(test_datastream_5, 14) == 26

if ARGV.size > 0
  input = ARGV[0]
  puts get_index_of_marker(input, 4)
  puts get_index_of_marker(input, 14)
end
