# https://adventofcode.com/2022/day/11

class Monkey
  property div, items, inspected_count

  @items : Array(Int64)
  @op : String
  @var : String
  @div : Int64
  @m_true : Int32
  @m_false : Int32
  @inspected_count : Int64 = 0

  def initialize(input : String)
    @items = input.lines[1].gsub("Starting items: ", "").split(", ").map(&.to_i64)
    @op, @var = input.lines[2].gsub(/\s*Operation: new = old /, "").split(" ")
    @div = input.lines[3].gsub("Test: divisible by ", "").to_i64
    @m_true = input.lines[4].chars.last.to_i
    @m_false = input.lines[5].chars.last.to_i
  end

  def throw_items(other_monkeys : Array(Monkey), &reduce : Int64 -> Int64)
    while item = @items.pop?
      @inspected_count += 1

      inc = @var =~ /\d+/ ? @var.to_i : item

      case @op
      when "*"
        item *= inc
      when "+"
        item += inc
      end

      item = reduce.call item

      receiving_monkey = item.divisible_by?(@div) ? @m_true : @m_false
      other_monkeys[receiving_monkey].items << item
    end
  end
end

# Part 1
def get_level_of_monkey_business_after_20_rounds(notes : String) : Int64
  monkeys = notes.split("\n\n").map { |m| Monkey.new(m) }

  20.times do
    monkeys.each(&.throw_items(monkeys, &.//(3)))
  end

  monkeys.map(&.inspected_count).sort.last(2).product
end

# Part 2
def get_level_of_monkey_business_after_10k_rounds(notes : String) : Int64
  monkeys = notes.split("\n\n").map { |m| Monkey.new(m) }
  all_div = monkeys.map(&.div).product

  10_000.times do
    monkeys.each(&.throw_items(monkeys, &.%(all_div)))
  end

  monkeys.map(&.inspected_count).sort.last(2).product
end

test_notes = <<-INPUT
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
INPUT

raise "Part 1 failed" unless get_level_of_monkey_business_after_20_rounds(test_notes) == 10605
raise "Part 2 failed" unless get_level_of_monkey_business_after_10k_rounds(test_notes) == 2713310158

if ARGV.size > 0
  input = ARGV[0]
  puts get_level_of_monkey_business_after_20_rounds(input)
  puts get_level_of_monkey_business_after_10k_rounds(input)
end
