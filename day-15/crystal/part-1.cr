grid = STDIN.gets_to_end.strip.split("\n").map(&.chars.map(&.to_i))
max = grid.size
distances = grid.dup.map { |l| l.map { |i| Int32::MAX } }

def adj(x, y, max)
  [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    .map { |i, j| {x + i, y + j} }
    .select { |px, py| 0 <= px < max && 0 <= py < max }
end

distances[0][0] = 0
unvisited = max.times.map { |x| max.times.map { |y| {x, y} } }.flatten.to_a
nx, ny = 0, 0
while true
  adjs = adj(nx, ny, max).select { |p| unvisited.includes? p }
  adjs.each do |ax, ay|
    "#{ax}:#{ay} : #{distances[ax][ay]} : #{distances[nx][ny]} : #{grid[ax][ay]}"
    distances[ax][ay] = Math.min(distances[ax][ay], distances[nx][ny] + grid[ax][ay])
  end
  unvisited.delete({nx, ny})
  break if unvisited.empty?
  nx, ny = unvisited.min_by { |x, y| distances[x][y] }
end
puts distances[max - 1][max - 1]
