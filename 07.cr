# https://adventofcode.com/2022/day/7

def get_directory_sizes(terminal_output : String) : Array(Int32)
  sizes = Hash(Path, Int32).new { 0 }
  cur_path = Path.posix("/")

  terminal_output.lines.each do |line|
    first, second, *rest = line.split(' ')

    if dir = line.match(/^\$ cd (.*)/).try &.captures.first
      cur_path = case dir
                 when ".."
                   cur_path.parent
                 when "/"
                   cur_path.root.not_nil!
                 else
                   cur_path / dir
                 end
    elsif size = line[/\d+/]?.try &.to_i
      ([cur_path] + cur_path.parents).each do |path|
        sizes[path] += size
      end
    end
  end

  sizes.values
end

# Part 1
def get_sum_of_small_directory_sizes(terminal_output : String) : Int32
  get_directory_sizes(terminal_output).select(&.<= 100_000).sum
end

# Part 2
def get_size_of_smallest_directory_to_delete(terminal_output : String) : Int32
  sizes = get_directory_sizes(terminal_output)

  total_size = 70_000_000
  free_size = total_size - sizes.first

  sizes[1..].select { |size| size + free_size >= 30_000_000 }.min
end

test_terminal_output = <<-CMD
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
CMD

raise "Part 1 failed" unless get_sum_of_small_directory_sizes(test_terminal_output) == 95437
raise "Part 2 failed" unless get_size_of_smallest_directory_to_delete(test_terminal_output) == 24933642

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_small_directory_sizes(input)
  puts get_size_of_smallest_directory_to_delete(input)
end
