rows = STDIN.gets_to_end.strip.split("\n").map { |l| l.chars.map(&.to_i) }

def adj(r, c)
  [{r, c + 1}, {r, c - 1}, {r + 1, c}, {r - 1, c}]
end

def adj_vals(rows, r, c)
  adj(r, c).reject(&.any?(&.negative?)).compact_map { |x, y| rows.dig?(x, y) }
end

points = rows.size.times.map { |r| rows.first.size.times.map { |c| {r, c} } }.flatten.to_a
minima = points.select { |r, c| adj_vals(rows, r, c).all?(&.> rows[r][c]) }
puts minima.flatten.map { |r, c| rows[r][c] }.map(&.+ 1).sum
