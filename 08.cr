# https://adventofcode.com/2022/day/8

DIRECTION_VECTORS = [{0, -1}, {-1, 0}, {0, 1}, {1, 0}]

def get_tree_map(tree_heights : String) : Hash(Tuple(Int32, Int32), Int32)
  map = Hash(Tuple(Int32, Int32), Int32).new

  tree_heights.lines.each.with_index do |line, y|
    line.chars.each.with_index do |height, x|
      map[{x, y}] = height.to_i
    end
  end

  map
end

# Part 1
def get_visible_tree_count(tree_heights : String) : Int32
  size = tree_heights.lines.size
  tree_map = get_tree_map(tree_heights)

  tree_map.count do |(coords, tree_height)|
    DIRECTION_VECTORS.any? do |(cx, cy)|
      cur_x, cur_y = coords

      loop do
        cur_x += cx
        cur_y += cy
        break true unless next_tree_height = tree_map[{cur_x, cur_y}]?
        break false if tree_height <= next_tree_height
      end
    end
  end
end

# Part 2
def get_highest_scenic_score(tree_heights : String) : Int32
  size = tree_heights.lines.size
  tree_map = get_tree_map(tree_heights)

  scenic_scores = tree_map.map do |(coords, tree_height)|
    DIRECTION_VECTORS.reduce(1) do |score, (cx, cy)|
      cur_x, cur_y = coords
      direction_score = 0

      loop do
        cur_x += cx
        cur_y += cy
        break unless next_tree_height = tree_map[{cur_x, cur_y}]?
        direction_score += 1
        break unless tree_height > next_tree_height
      end

      direction_score * score
    end
  end

  scenic_scores.max
end

test_tree_heights = <<-INPUT
30373
25512
65332
33549
35390
INPUT

raise "Part 1 failed" unless get_visible_tree_count(test_tree_heights) == 21
raise "Part 2 failed" unless get_highest_scenic_score(test_tree_heights) == 8

if ARGV.size > 0
  input = ARGV[0]
  puts get_visible_tree_count(input)
  puts get_highest_scenic_score(input)
end
