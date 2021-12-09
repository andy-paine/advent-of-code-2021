rows = STDIN.gets_to_end.strip.split("\n").map { |l| l.chars.map(&.to_i) }

def adj(r, c)
  [{r, c + 1}, {r, c - 1}, {r + 1, c}, {r - 1, c}]
end

def adj_vals(rows, r, c)
  adj(r, c).reject(&.any?(&.negative?)).compact_map { |x, y| rows.dig?(x, y) }
end

points = rows.size.times.map { |r| rows.first.size.times.map { |c| {r, c} } }.flatten.to_a
points.reject! { |r, c| rows[r][c] == 9 }
bowls = points.select { |r, c| adj_vals(rows, r, c).all?(&.> rows[r][c]) }.map { |x| [x] }
points.cycle do |r, c|
  bowl = bowls.find { |b| adj(r, c).any? { |x| b.includes? x } }
  bowl.push(points.delete({r, c}).not_nil!) if bowl
  break if points.empty?
end

puts bowls.map(&.uniq).map(&.size).sort.last(3).product
