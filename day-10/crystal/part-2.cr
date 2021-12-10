lines = STDIN.gets_to_end.strip.split("\n")
braces = {'[' => ']', '{' => '}', '(' => ')', '<' => '>'}
scores = {'(' => 1, '[' => 2, '{' => 3, '<' => 4}
lines = lines.compact_map do |s|
  s.chars.reduce([] of Char) do |seen, c|
    next seen.unshift(c) if braces.has_key? c
    c == braces[seen.shift] ? seen : break [c]
  end
end
incomplete = lines.reject { |l| braces.values.includes? l.first }.map { |s| s.reduce(0_i64) { |t, c| t*5 + scores[c] } }
puts incomplete.sort[(incomplete.size/2).to_i]
