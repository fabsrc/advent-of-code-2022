# https://adventofcode.com/2022/day/25

# Part 1
def get_sum_of_snafu_numbers(numbers : String) : String
  sum = numbers.lines.sum do |number|
    number.chars.each.with_index(1).sum do |c, pos|
      place_value = 5_i64 ** (number.size - pos)

      case c
      when .number?
        place_value * c.to_i
      when '-'
        place_value * -1
      when '='
        place_value * -2
      else
        0_i64
      end
    end
  end

  n = sum
  snafu_sum = ""

  while n > 0
    n, rem = n.divmod(5)

    if rem == 4
      rem = -1
      n += 1
      snafu_sum = '-' + snafu_sum
    elsif rem == 3
      rem = -2
      n += 1
      snafu_sum = '=' + snafu_sum
    else
      snafu_sum = rem.to_s + snafu_sum
    end
  end

  snafu_sum
end

test_numbers = <<-INPUT
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
INPUT

raise "Part 1 failed" unless get_sum_of_snafu_numbers(test_numbers) == "2=-1=0"

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_snafu_numbers(input)
end
