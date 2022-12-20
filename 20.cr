# https://adventofcode.com/2022/day/20

# Part 1
def get_sum_of_decrypted_coordinates(encrypted_file : Array(Int32)) : Int32
  encrypted_file = encrypted_file.map_with_index { |n, idx| {idx, n} }
  decrypted_file = encrypted_file.dup

  encrypted_file.each do |curr|
    idx = decrypted_file.index!(curr)
    new_idx = idx + curr[1]
    new_idx = new_idx % (decrypted_file.size - 1)
    decrypted_file.delete_at(idx)
    decrypted_file.insert(new_idx, curr)
  end

  zero_idx = decrypted_file.index! { |idx, n| n == 0 }
  decrypted_file[(zero_idx + 1000) % decrypted_file.size][1] +
    decrypted_file[(zero_idx + 2000) % decrypted_file.size][1] +
    decrypted_file[(zero_idx + 3000) % decrypted_file.size][1]
end

# Part 2
def get_sum_of_decrypted_coordinates_with_decryption_key(encrypted_file : Array(Int32)) : Int64
  encrypted_file = encrypted_file.map_with_index { |n, id| {id, n.to_i64 * 811589153_i64} }
  decrypted_file = encrypted_file.dup

  10.times do
    encrypted_file.each do |curr|
      idx = decrypted_file.index!(curr)
      new_idx = idx.to_i64 + curr[1]
      new_idx = new_idx % (decrypted_file.size - 1)
      decrypted_file.delete_at(idx)
      decrypted_file.insert(new_idx, curr)
    end
  end

  zero_idx = decrypted_file.index! { |id, n| n == 0 }
  decrypted_file[(zero_idx + 1000) % decrypted_file.size][1] +
    decrypted_file[(zero_idx + 2000) % decrypted_file.size][1] +
    decrypted_file[(zero_idx + 3000) % decrypted_file.size][1]
end

test_encrypted_file = [1, 2, -3, 3, -2, 0, 4]

raise "Part 1 failed" unless get_sum_of_decrypted_coordinates(test_encrypted_file) == 3
raise "Part 2 failed" unless get_sum_of_decrypted_coordinates_with_decryption_key(test_encrypted_file) == 1623178306

if ARGV.size > 0
  input = ARGV[0].lines.map(&.to_i)
  puts get_sum_of_decrypted_coordinates(input)
  puts get_sum_of_decrypted_coordinates_with_decryption_key(input)
end
