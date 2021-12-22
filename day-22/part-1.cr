grid = Array(Array(Array(Bool))).new(101) {
  Array(Array(Bool)).new(101) {
    Array(Bool).new(101, false)
  }
}

record Instruction, op : Bool, xs : Int32, xe : Int32, ys : Int32, ye : Int32, zs : Int32, ze : Int32

ins = STDIN.gets_to_end.strip.split("\n")
  .compact_map { |l| /(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/.match l }
  .map { |m| Instruction.new m[1] == "on", m[2].to_i, m[3].to_i, m[4].to_i, m[5].to_i, m[6].to_i, m[7].to_i }

def min(v); Math.min(Math.max(v+50, 0), 101) end
def max(v); Math.min(Math.max(v+50, -1), 100) end

def points(xs, xe, ys, ye, zs, ze) : Array(Tuple(Int32, Int32, Int32))
  (min(xs)..max(xe)).map do |x|
    (min(ys)..max(ye)).map do |y|
      (min(zs)..max(ze)).map do |z|
        {x, y, z}
      end
    end
  end.flatten
end

grid = ins.reduce(grid) do |grid,i|
  points(i.xs,i.xe,i.ys,i.ye,i.zs,i.ze).each do |x,y,z|
    grid[x][y][z] = i.op
  end
  grid
end
puts grid.flatten.count(&.itself)
