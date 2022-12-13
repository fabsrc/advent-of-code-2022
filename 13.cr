# https://adventofcode.com/2022/day/13

require "json"

def compare_values(left : JSON::Any?, right : JSON::Any?) : Bool?
  return true if left.nil?
  return false if right.nil?

  if left.as_a? && right.as_a?
    [left.as_a.size, right.as_a.size].max.times do |idx|
      result = compare_values(left[idx]?, right[idx]?)
      return result unless result.nil?
    end
  end

  if left.as_a? && right.as_i?
    return compare_values(left, JSON::Any.new([right]))
  end

  if left.as_i? && right.as_a?
    return compare_values(JSON::Any.new([left]), right)
  end

  if left.as_i? && right.as_i?
    left = left.as_i
    right = right.as_i

    if left > right
      return false
    elsif left < right
      return true
    end
  end
end

# Part 1
def get_sum_of_correct_packet_indexes(packet_list : String) : Int32
  pairs = packet_list.split("\n\n").map(&.lines.map { |l| JSON.parse(l) })

  pairs.each.with_index(1).sum do |(left, right), idx|
    compare_values(left, right) ? idx : 0
  end
end

# Part 2
def get_decoder_key(packet_list : String) : Int32
  divider_1 = [[2]]
  divider_2 = [[6]]

  packets =
    (packet_list + "\n#{divider_1}\n#{divider_2}")
      .lines
      .compact_map { |l| JSON.parse(l) unless l.empty? }
      .sort { |left, right| compare_values(left, right) ? -1 : 1 }

  (packets.index!(divider_1) + 1) * (packets.index!(divider_2) + 1)
end

test_packet_list = <<-INPUT
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
INPUT

raise "Part 1 failed" unless get_sum_of_correct_packet_indexes(test_packet_list) == 13
raise "Part 2 failed" unless get_decoder_key(test_packet_list) == 140

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_correct_packet_indexes(input)
  puts get_decoder_key(input)
end
