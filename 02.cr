# https://adventofcode.com/2022/day/2

# Part 1
def get_total_rps_score(strategy : Array(Array(Char))) : Int32
  strategy.reduce(0) do |score, (op_shape, shape)|
    case {op_shape, shape}
    when {'A', 'Y'}, {'B', 'Z'}, {'C', 'X'} # win
      score += 6
    when {'A', 'X'}, {'B', 'Y'}, {'C', 'Z'} # draw
      score += 3
    end

    score + shape.ord - 87
  end
end

# Part 2
def get_total_rps_score_2(strategy : Array(Array(Char))) : Int32
  strategy.reduce(0) do |score, (op_shape, outcome)|
    op_index = op_shape.ord - 68

    case outcome
    when 'X' # lose
      score += {3, 1, 2}[op_index]
    when 'Y' # draw
      score += 3 + {1, 2, 3}[op_index]
    when 'Z' # win
      score += 6 + {2, 3, 1}[op_index]
    end

    score
  end
end

test_strategy = [
  ['A', 'Y'],
  ['B', 'X'],
  ['C', 'Z'],
]
raise "Part 1 failed" unless get_total_rps_score(test_strategy) === 15
raise "Part 2 failed" unless get_total_rps_score_2(test_strategy) === 12

if ARGV.size > 0
  input = ARGV[0].split("\n").map(&.split(" ").map(&.char_at(0)))
  puts get_total_rps_score(input)
  puts get_total_rps_score_2(input)
end
