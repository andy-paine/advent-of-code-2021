lines = STDIN.gets_to_end.strip.split("\n").map { |l| l.split(" | ").map(&.split) }
letters = {"abcefg" => 0, "cf" => 1, "acdeg" => 2, "acdfg" => 3, "bcdf" => 4, "abdfg" => 5, "abdefg" => 6, "acf" => 7, "abcdefg" => 8, "abcdfg" => 9}
nums = lines.map do |l|
  mapping = "abcdefg".chars.permutations.map { |p| "abcdefg".chars.zip(p).to_h }.select do |perm|
    l.first.map { |w| w.chars.map { |c| perm[c] }.sort.join }.all? { |w| letters.has_key? w }
  end.first
  l.last.map { |x| x.chars.map { |c| mapping[c] }.sort.join }.map { |w| letters[w] }.join.to_i
end
puts nums.sum
