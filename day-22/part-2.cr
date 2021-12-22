alias Cuboid = Tuple(Range(Int32, Int32), Range(Int32, Int32), Range(Int32, Int32))
record Instruction, line : String, op : Bool, cuboid : Cuboid

ins = STDIN.gets_to_end.strip.split("\n")
  .compact_map { |l| /(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/.match l }
  .map { |m| Instruction.new m[0], m[1] == "on", {(m[2].to_i..m[3].to_i), (m[4].to_i..m[5].to_i), (m[6].to_i..m[7].to_i)} }

def overlaps?(a, b)
  (0..2).all? { |i| b[i].any?{|bi| a[i].includes? bi}}
end

def intersection(a : Cuboid, b : Cuboid) : Cuboid
  {0,1,2}.map{|i| intersect(a[i], b[i])}
end

def intersect(a : Range(Int32, Int32), b : Range(Int32, Int32)) : Range(Int32, Int32)
  case
  when a.begin <= b.begin && a.end <= b.end
    (b.begin..a.end)
  when a.begin <= b.begin && a.end >= b.end
    b
  when a.begin > b.begin && a.end > b.end
    (a.begin..b.end)
  else
    a
  end
end

def mag(c : Cuboid, v : Int32)
  v.to_i64 * (0..2).map{|i| c[i].end - c[i].begin + 1}.map(&.to_i64).product
end

cuboids = Hash(Cuboid, Int32).new(0)
ins.each do |i|
  actions = Hash(Cuboid, Int32).new(0)
  cuboids.each do |c,v|
    next unless overlaps? i.cuboid, c
    inter = intersection(i.cuboid, c)
    actions[inter] -= v
  end
  if i.op
    actions[i.cuboid] += 1
  end
  actions.each {|k,v| cuboids[k] += v}
end
puts cuboids.map{|c| mag *c}.map(&.to_i64).sum
