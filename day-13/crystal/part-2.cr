points, ins = STDIN.gets_to_end.strip.split("\n\n").map(&.split("\n"))
points = points.map { |p| Tuple(Int32, Int32).from(p.split(",").map(&.to_i)) }
grid = (points.map(&.last).max + 1).times.map { |r| (points.map(&.first).max + 1).times.map { |c| false }.to_a }.to_a
points.each { |x, y| grid[y][x] = true }
ins = ins.map do |i|
  regex = /fold along ([yx])=([0-9]+)/.match(i).not_nil![1,2]
  {regex[0], regex[1].to_i}
end

def fold(grid, dir, loc)
  grid = grid.transpose if dir == "x"
  grid = fold_y(grid, loc)
  grid = grid.transpose if dir == "x"
  grid
end

def fold_y(grid, y)
  top = grid[..y-1]
  bottom = grid[y+1..]
  bottom.each_with_index do |b,by|
    top[-1*(by+1)] = top[-1*(by+1)].zip(b).map{|a,b| a||b}
  end
  top
end

grid = ins.reduce(grid) {|grid,i| fold(grid,*i)}
grid.each {|l| puts l.map{|c| c ? "⬛" : "⬜"}.join}
