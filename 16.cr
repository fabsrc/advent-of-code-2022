# https://adventofcode.com/2022/day/16

class Valve
  getter id, flow_rate
  property connections

  def initialize(@id : String, @flow_rate : Int32)
    @connections = [] of Valve
  end
end

struct Outcome
  @@total_time = 0
  getter own_path, elephant_path, open_valves

  def self.total_time=(total_time : Int32)
    @@total_time = total_time
  end

  def initialize(
    @open_valves : Hash(Valve, Int32),
    @own_path : Array(Valve),
    @elephant_path = [] of Valve
  )
  end

  def released_pressure
    @open_valves.sum { |valve, time| (@@total_time - time) * valve.flow_rate }
  end
end

def get_valves(scan : String) : {Hash(String, Valve), Array(Valve)}
  valves = Hash(String, Valve).new

  id_connections = scan.lines.map do |line|
    a, b = line.split("; ")
    id = a[/[A-Z]{2}/]
    flow_rate = a[/\d+/]
    valves[id] = Valve.new(id, flow_rate.to_i)
    connections = b.gsub(/tunnels? leads? to valves? /, "").split(", ")
    {id, connections}
  end
  id_connections.each do |(id, connections)|
    connections.each do |conn|
      valves[id].connections << valves[conn]
    end
  end

  valves_to_open = valves.values.select { |v| v.flow_rate > 0 }

  {valves, valves_to_open}
end

# Part 1
def get_max_released_pressure(scan : String) : Int32
  Outcome.total_time = 30
  valves, valves_to_open = get_valves(scan)
  start = Outcome.new(Hash(Valve, Int32).new, [valves["AA"]])
  best_outcome = start
  possible_outcomes = [start]

  1.upto(30) do |time|
    new_outcomes = [] of Outcome

    possible_outcomes.each do |po|
      next if po.open_valves.size == valves_to_open.size

      if !po.open_valves.has_key?(po.own_path.last) && valves_to_open.includes?(po.own_path.last)
        open_valves = po.open_valves.clone
        open_valves[po.own_path.last] = time
        new_outcomes << Outcome.new(open_valves, po.own_path + [po.own_path.last])
      end

      po.own_path.last.connections.each do |valve|
        new_outcomes << Outcome.new(po.open_valves, po.own_path + [valve])
      end
    end

    possible_outcomes = new_outcomes.sort_by(&.released_pressure).reverse.first(1000)

    if possible_outcomes.first.released_pressure > best_outcome.released_pressure
      best_outcome = possible_outcomes.first
    end
  end

  best_outcome.released_pressure
end

# Part 2
def get_max_released_pressure_with_help(scan : String) : Int32
  Outcome.total_time = 26
  valves, valves_to_open = get_valves(scan)
  start = Outcome.new(Hash(Valve, Int32).new, [valves["AA"]], [valves["AA"]])
  best_outcome = start
  possible_outcomes = [start]

  1.upto(26) do |time|
    new_outcomes = [] of Outcome

    possible_outcomes.each do |po|
      next if po.open_valves.size == valves_to_open.size

      open_own = !po.open_valves.has_key?(po.own_path.last) && valves_to_open.includes?(po.own_path.last)
      open_elephant = !po.open_valves.has_key?(po.elephant_path.last) && valves_to_open.includes?(po.elephant_path.last)

      if open_own || open_elephant
        open_valves = po.open_valves.clone

        own_paths = if open_own
                      open_valves[po.own_path.last] = time
                      [po.own_path + [po.own_path.last]]
                    else
                      po.own_path.last.connections.map { |conn| po.own_path + [conn] }
                    end

        elephant_paths = if open_elephant
                           open_valves[po.elephant_path.last] = time
                           [po.elephant_path + [po.elephant_path.last]]
                         else
                           po.elephant_path.last.connections.map { |conn| po.elephant_path + [conn] }
                         end

        own_paths.cartesian_product(elephant_paths).each do |(own, elephant)|
          new_outcomes << Outcome.new(open_valves, own, elephant)
        end
      end

      po.own_path.last.connections
        .cartesian_product(po.elephant_path.last.connections)
        .reject { |(own, elephant)| own == elephant }
        .each do |(own, elephant)|
          new_outcomes << Outcome.new(po.open_valves, po.own_path + [own], po.elephant_path + [elephant])
        end
    end

    possible_outcomes = new_outcomes.sort_by(&.released_pressure).reverse.first(10_000)

    if possible_outcomes.first.released_pressure > best_outcome.released_pressure
      best_outcome = possible_outcomes.first
    end
  end

  best_outcome.released_pressure
end

test_scan = <<-INPUT
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
INPUT

raise "Part 1 failed" unless get_max_released_pressure(test_scan) == 1651
raise "Part 2 failed" unless get_max_released_pressure_with_help(test_scan) == 1707

if ARGV.size > 0
  input = ARGV[0]
  puts get_max_released_pressure(input)
  puts get_max_released_pressure_with_help(input)
end
