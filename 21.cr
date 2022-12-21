# https://adventofcode.com/2022/day/21

# Part 1
def get_root_number(monkey_list : String) : Int64
  monkeys = monkey_list.lines.map(&.split(": ")).to_h

  until monkeys["root"] =~ /^\d+$/
    monkeys.each do |(monkey, yell)|
      if match = yell.match(/^(\d+|[a-z]+) (\+|\/|\*|\-) (\d+|[a-z]+)$/)
        left = match[1]
        op = match[2]
        right = match[3]

        if left =~ /^\d+$/ && right =~ /^\d+$/
          left = left.to_i64
          right = right.to_i64
          case op
          when "+"
            monkeys[monkey] = (left + right).to_s
          when "-"
            monkeys[monkey] = (left - right).to_s
          when "/"
            monkeys[monkey] = (left // right).to_s
          when "*"
            monkeys[monkey] = (left * right).to_s
          end
        else
          monkeys[monkey] = monkeys[monkey].gsub(Regex.new("#{left}|#{right}")) do |m|
            monkeys[m]? =~ /^\d+$/ ? monkeys[m] : m
          end
        end
      end
    end
  end

  monkeys["root"].to_i64
end

# Part 2
def get_humn_number(monkey_list : String) : Int64
  monkeys = monkey_list.lines.map(&.split(": ")).to_h

  until monkeys["root"] =~ /\d+/
    monkeys.each do |(monkey, yell)|
      if match = yell.match(/^(\d+|[a-z]+) (\+|\/|\*|\-) (\d+|[a-z]+)$/)
        left = match[1]
        op = match[2]
        right = match[3]

        next if left == "humn" || right == "humn"

        if left =~ /^\d+$/ && right =~ /^\d+$/
          left = left.to_i64
          right = right.to_i64
          case op
          when "+"
            monkeys[monkey] = (left + right).to_s
          when "-"
            monkeys[monkey] = (left - right).to_s
          when "/"
            monkeys[monkey] = (left // right).to_s
          when "*"
            monkeys[monkey] = (left * right).to_s
          end
        else
          monkeys[monkey] = monkeys[monkey].gsub(Regex.new("#{left}|#{right}")) do |m|
            monkeys[m]? =~ /^\d+$/ ? monkeys[m] : m
          end
        end
      end
    end
  end

  left, _, right = monkeys["root"].split(" ")
  number = right.to_i64
  current_monkey = monkeys[left]

  until current_monkey =~ /humn/
    if match = current_monkey.match(/^(\d+|[a-z]+) (\+|\/|\*|\-) (\d+|[a-z]+)$/)
      left = match[1]
      op = match[2]
      right = match[3]

      current_number = left =~ /^\d+$/ ? left.to_i64 : right.to_i64

      case op
      when "+"
        number -= current_number
      when "-"
        if left =~ /^\d+$/
          number *= -1
          number += current_number
        else
          number += current_number
        end
      when "/"
        number *= current_number
      when "*"
        number //= current_number
      end

      if left =~ /[a-z]+/
        current_monkey = monkeys[left]
      else
        current_monkey = monkeys[right]
      end
    end
  end

  _, _, right = current_monkey.split(" ")
  monkeys[right].to_i64 + number
end

test_monkey_list = <<-INPUT
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
INPUT

raise "Part 1 failed" unless get_root_number(test_monkey_list) == 152
raise "Part 2 failed" unless get_humn_number(test_monkey_list) == 301

if ARGV.size > 0
  input = ARGV[0]
  puts get_root_number(input)
  puts get_humn_number(input)
end
