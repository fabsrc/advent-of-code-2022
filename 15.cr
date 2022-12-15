# https://adventofcode.com/2022/day/15

class Sensor
  def initialize(sx : Int32, sy : Int32, bx : Int32, by : Int32)
    @x = sx
    @y = sy
    @radius = (sx - bx).abs + (sy - by).abs
  end

  def in_range?(coord : {Int32, Int32}) : Bool
    (coord[0] - @x).abs + (coord[1] - @y).abs <= @radius
  end

  def each_circumference_point(offset = 0)
    radius = @radius + offset

    right = {@x + radius, @y}
    bottom = {@x, @y + radius}
    left = {@x - radius, @y}
    top = {@x, @y - radius}

    r_to_b = {right, bottom, -1, 1}
    b_to_l = {bottom, left, -1, -1}
    l_to_t = {left, top, 1, -1}
    t_to_r = {top, right, 1, 1}

    [r_to_b, b_to_l, l_to_t, t_to_r].each do |(curr, dest, dx, dy)|
      until curr == dest
        curr = {curr[0] + dx, curr[1] + dy}
        yield curr
      end
    end
  end
end

def get_sensors_and_beacons(sensor_report : String) : {Array(Sensor), Set({Int32, Int32})}
  sensors = [] of Sensor
  beacons = Set({Int32, Int32}).new

  sensor_report.lines.each do |line|
    sensor, beacon = line.split(": ")
    sx, sy = sensor.split(", ").map(&.[/-?\d+/].to_i)
    bx, by = beacon.split(", ").map(&.[/-?\d+/].to_i)
    sensors << Sensor.new(sx, sy, bx, by)
    beacons.add({bx, by})
  end

  {sensors, beacons}
end

# Part 1
def get_positions_without_beacon(sensor_report : String, row : Int32) : Int32
  sensors, beacons = get_sensors_and_beacons(sensor_report)
  points = Set({Int32, Int32}).new

  sensors.each do |sensor|
    sensor.each_circumference_point do |(x, y)|
      points << {x, y} if y == row && !beacons.includes?({x, y})
    end
  end

  min, max = points.select { |(x, y)| y == row }.minmax_of(&.[0])
  becon_count = beacons.count { |(x, y)| y == row }

  (min..max).size - becon_count
end

# Part 2
def get_tuning_frequency(sensor_report : String, max : Int32) : Int64
  sensors = get_sensors_and_beacons(sensor_report).first

  sensors.each do |sensor|
    sensor.each_circumference_point(1) do |(x, y)|
      if (0..max).includes?(x) && (0..max).includes?(y)
        any_in_range = sensors.any? do |sensor|
          sensor.in_range?({x, y})
        end

        return x.to_i64 * 4_000_000_i64 + y.to_i64 unless any_in_range
      end
    end
  end

  raise "No result"
end

test_sensor_report = <<-INPUT
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
INPUT

raise "Part 1 failed" unless get_positions_without_beacon(test_sensor_report, 10) == 26
raise "Part 2 failed" unless get_tuning_frequency(test_sensor_report, 20) == 56000011

if ARGV.size > 0
  input = ARGV[0]
  puts get_positions_without_beacon(input, 2_000_000)
  puts get_tuning_frequency(input, 4_000_000)
end
