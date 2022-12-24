# https://adventofcode.com/2022/day/19

struct Outcome
  def_hash @ore, @clay, @obsidian, @geode, @ore_robots, @clay_robots, @obsidian_robots, @geode_robots
  getter ore_robots, clay_robots, obsidian_robots, geode_robots
  property ore, clay, obsidian, geode, new_robot

  @ore : Int32 = 0
  @clay : Int32 = 0
  @obsidian : Int32 = 0
  @geode : Int32 = 0

  @ore_robots : Int32 = 1
  @clay_robots : Int32 = 0
  @obsidian_robots : Int32 = 0
  @geode_robots : Int32 = 0

  @new_robot : Symbol? = nil

  def tick
    @ore += @ore_robots
    @clay += @clay_robots
    @obsidian += @obsidian_robots
    @geode += @geode_robots

    @ore_robots += 1 if @new_robot == :ore
    @clay_robots += 1 if @new_robot == :clay
    @obsidian_robots += 1 if @new_robot == :obsidian
    @geode_robots += 1 if @new_robot == :geode

    @new_robot = nil

    self
  end
end

def get_blueprints(blueprint_input : String)
  blueprint_input.lines.map do |line|
    numbers = [] of Int32
    line.gsub(/^Blueprint \d+: /, "").scan(/\d+/) do |match|
      numbers << match[0].to_i
    end
    {
      ore:      {ore: numbers[0]},
      clay:     {ore: numbers[1]},
      obsidian: {ore: numbers[2], clay: numbers[3]},
      geode:    {ore: numbers[4], obsidian: numbers[5]},
    }
  end
end

# Part 1
def get_sum_of_quality_levels(blueprint_input : String) : Int32
  blueprints = get_blueprints(blueprint_input)

  max_geodes = blueprints.map do |blueprint|
    outcomes = Deque.new([Outcome.new])
    outcome_hashes = Set.new(outcomes.map(&.hash))

    max_ore = blueprint.values.max_of(&.[:ore])
    max_clay = blueprint.values.select(&.has_key?(:clay)).max_of { |a| a[:clay]? || 0 }
    max_obsidian = blueprint.values.select(&.has_key?(:obsidian)).max_of { |a| a[:obsidian]? || 0 }
    max_geode = 0

    24.times do |i|
      outcomes.size.times do
        outcome = outcomes.shift.tick

        max_geode = outcome.geode if outcome.geode > max_geode

        if blueprint[:geode][:ore] <= outcome.ore && blueprint[:geode][:obsidian] <= outcome.obsidian
          new_outcome = outcome.dup
          new_outcome.new_robot = :geode
          new_outcome.ore -= blueprint[:geode][:ore]
          new_outcome.obsidian -= blueprint[:geode][:obsidian]
          outcomes << new_outcome
          next
        end

        if blueprint[:obsidian][:ore] <= outcome.ore &&
           blueprint[:obsidian][:clay] <= outcome.clay &&
           outcome.obsidian_robots * (24 - i) + outcome.obsidian < (24 - i) * max_obsidian
          new_outcome = outcome.dup
          new_outcome.new_robot = :obsidian
          new_outcome.ore -= blueprint[:obsidian][:ore]
          new_outcome.clay -= blueprint[:obsidian][:clay]
          outcomes << new_outcome
        end

        if blueprint[:clay][:ore] <= outcome.ore && outcome.clay_robots * (24 - i) + outcome.clay < (24 - i) * max_clay
          new_outcome = outcome.dup
          new_outcome.new_robot = :clay
          new_outcome.ore -= blueprint[:clay][:ore]
          outcomes << new_outcome
        end

        if blueprint[:ore][:ore] <= outcome.ore && outcome.ore_robots * (24 - i) + outcome.ore < (24 - i) * max_ore
          new_outcome = outcome.dup
          new_outcome.new_robot = :ore
          new_outcome.ore -= blueprint[:ore][:ore]
          outcomes << new_outcome
        end

        next if outcome.ore > max_ore * 3 || outcome.clay > max_clay * 3 || outcome.obsidian > max_obsidian * 3

        unless outcome_hashes.includes?(outcome.hash)
          outcomes << outcome
          outcome_hashes.add(outcome.hash)
        end
      end
    end

    max_geode
  end

  max_geodes.each_with_index(1).sum { |max_geode, idx| max_geode * idx }
end

# Part 2
def get_product_of_max_geodes(blueprint_input : String) : Int32
  blueprints = get_blueprints(blueprint_input)

  max_geodes = blueprints.first(3).map do |blueprint|
    outcomes = Deque.new([Outcome.new])
    outcome_hashes = Set.new(outcomes.map(&.hash))

    max_ore = blueprint.values.max_of(&.[:ore])
    max_clay = blueprint.values.select(&.has_key?(:clay)).max_of { |a| a[:clay]? || 0 }
    max_obsidian = blueprint.values.select(&.has_key?(:obsidian)).max_of { |a| a[:obsidian]? || 0 }
    max_geode = 0

    32.times do |i|
      outcomes.size.times do
        outcome = outcomes.shift.tick

        max_geode = outcome.geode if outcome.geode > max_geode

        if blueprint[:geode][:ore] <= outcome.ore && blueprint[:geode][:obsidian] <= outcome.obsidian
          new_outcome = outcome.dup
          new_outcome.new_robot = :geode
          new_outcome.ore -= blueprint[:geode][:ore]
          new_outcome.obsidian -= blueprint[:geode][:obsidian]
          outcomes << new_outcome
          next
        end

        if blueprint[:obsidian][:ore] <= outcome.ore &&
           blueprint[:obsidian][:clay] <= outcome.clay &&
           outcome.obsidian_robots * (32 - i) + outcome.obsidian < (32 - i) * max_obsidian
          new_outcome = outcome.dup
          new_outcome.new_robot = :obsidian
          new_outcome.ore -= blueprint[:obsidian][:ore]
          new_outcome.clay -= blueprint[:obsidian][:clay]
          outcomes << new_outcome
        end

        if blueprint[:clay][:ore] <= outcome.ore && outcome.clay_robots * (32 - i) + outcome.clay < (32 - i) * max_clay
          new_outcome = outcome.dup
          new_outcome.new_robot = :clay
          new_outcome.ore -= blueprint[:clay][:ore]
          outcomes << new_outcome
        end

        if blueprint[:ore][:ore] <= outcome.ore && outcome.ore_robots * (32 - i) + outcome.ore < (32 - i) * max_ore
          new_outcome = outcome.dup
          new_outcome.new_robot = :ore
          new_outcome.ore -= blueprint[:ore][:ore]
          outcomes << new_outcome
        end

        next if outcome.ore > max_ore * 4 || outcome.clay > max_clay * 4 || outcome.obsidian > max_obsidian * 4

        unless outcome_hashes.includes?(outcome.hash)
          outcomes << outcome
          outcome_hashes.add(outcome.hash)
        end
      end
    end

    max_geode
  end

  max_geodes.product
end

test_blueprint_input = <<-INPUT
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
INPUT

raise "Part 1 failed" unless get_sum_of_quality_levels(test_blueprint_input) == 33
raise "Part 2 failed" unless get_product_of_max_geodes(test_blueprint_input) == 3472

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_quality_levels(input)
  puts get_product_of_max_geodes(input)
end
