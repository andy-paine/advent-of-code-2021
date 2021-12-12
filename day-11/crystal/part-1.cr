def adj(r, c)
  (-1..1).map { |i| (-1..1).map { |j| {r + i, c + j} } }.flatten.select { |x, y| 0 <= x < 10 && 0 <= y < 10 }
end

octs = STDIN.gets_to_end.strip.split("\n").map { |l| l.chars.map(&.to_i) }
total = 100.times.reduce(0) do |total|
  octs.map!(&.map(&.+ 1))
  while octs.flatten.any?(&.> 9)
    flashes = octs.map_with_index { |l, r| l.map_with_index { |v, c| v > 9 ? {r, c} : nil } }.flatten.compact
    flashes.each { |nr, nc| adj(nr, nc).each { |r, c| octs[r][c] += 1 }; octs[nr][nc] = Int32::MIN }
  end
  octs.map! { |l| l.map { |c| c < 0 ? 0 : c } }
  total + octs.flatten.select(&.zero?).size
end
puts total
