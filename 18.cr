# https://adventofcode.com/2022/day/18

DIRECTIONS = [{1, 0, 0}, {-1, 0, 0}, {0, 1, 0}, {0, -1, 0}, {0, 0, 1}, {0, 0, -1}]

# Part 1
def get_total_surface_area(cubes_coords : String) : Int32
  cubes = cubes_coords.lines.map { |l| Tuple(Int32, Int32, Int32).from(l.split(',').map(&.to_i)) }

  cubes.sum do |(x, y, z)|
    DIRECTIONS.count do |(dx, dy, dz)|
      !cubes.includes?({x + dx, y + dy, z + dz})
    end
  end
end

# Part 2
def get_exterior_surface_area(cubes_coords : String) : Int32
  cubes = cubes_coords.lines.map { |l| Tuple(Int32, Int32, Int32).from(l.split(',').map(&.to_i)) }

  min_x = cubes.min_of(&.[0]) - 1
  max_x = cubes.max_of(&.[0]) + 1
  min_y = cubes.min_of(&.[1]) - 1
  max_y = cubes.max_of(&.[1]) + 1
  min_z = cubes.min_of(&.[2]) - 1
  max_z = cubes.max_of(&.[2]) + 1
  outside = Set({Int32, Int32, Int32}).new
  queue = [{min_x, min_y, min_z}]

  while current = queue.pop?
    x, y, z = current

    next if cubes.includes?(current)
    next unless (min_x..max_x).includes?(x) && (min_y..max_y).includes?(y) && (min_z..max_z).includes?(z)

    unless outside.includes?(current)
      outside.add(current)
      DIRECTIONS.each do |(dx, dy, dz)|
        queue.push({x + dx, y + dy, z + dz})
      end
    end
  end

  cubes.sum do |(x, y, z)|
    DIRECTIONS.count do |(dx, dy, dz)|
      outside.includes?({x + dx, y + dy, z + dz})
    end
  end
end

test_cube_coords = <<-INPUT
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
INPUT

raise "Part 1 failed" unless get_total_surface_area(test_cube_coords) == 64
raise "Part 2 failed" unless get_exterior_surface_area(test_cube_coords) == 58

if ARGV.size > 0
  input = ARGV[0]
  puts get_total_surface_area(input)
  puts get_exterior_surface_area(input)
end
