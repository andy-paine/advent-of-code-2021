lines = STDIN.gets_to_end.strip.split("\n").map { |l| l.split(" | ").last.split }
letters = {0 => "abcefg", 1 => "cf", 2 => "acdeg", 3 => "acdfg", 4 => "bcdf", 5 => "abdfg", 6 => "abdefg", 7 => "acf", 8 => "abcdefg", 9 => "abcdfg"}
lengths = letters.values.map(&.size).tally.select { |_, l| l == 1 }.keys
puts lines.map { |l| l.count { |s| lengths.includes? s.size } }.sum
