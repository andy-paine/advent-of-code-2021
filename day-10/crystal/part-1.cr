lines = STDIN.gets_to_end.strip.split("\n")
braces = {'[' => ']', '{' => '}', '(' => ')', '<' => '>'}
score = lines.compact_map do |s|
  seen = [] of Char
  s.chars.find { |c| braces.keys.includes?(c) ? seen.unshift(c).empty? : c != braces[seen.shift] }
end.map { |x| {')' => 3, ']' => 57, '}' => 1197, '>' => 25137}[x] }.sum
puts score
