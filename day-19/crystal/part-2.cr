alias Point = Tuple(Int32, Int32, Int32)

def rotate(p)
  3.times.reduce([p]) do |ps|
    x, y, z = ps.last
    ps + [{-y, x, z}]
  end
end

def paired?(a, b)
  a_dists = distances(a)
  b.find do |rot|
    b_dists = distances(rot)
    a_dists.each do |adk, ad|
      b_dists.each do |bdk, bd|
        shared = bd & ad
        if shared.size >= 6
          dx, dy, dz = (0..2).map { |i| bdk[i] - adk[i] }
        return {rot.map { |x, y, z| {x - dx, y - dy, z - dz} }, {dx,dy,dz}}
        end
      end
    end
  end
  nil
end

def distances(points : Array(Point))
  points.map do |x1, y1, z1|
    { {x1, y1, z1}, points.map { |x2, y2, z2| {x2 - x1, y2 - y1, z2 - z1} } }
  end.to_h
end

def rotations(p : Point)
  x, y, z = p
  [{x, y, z}, {-x, y, -z}, {-z, y, x}, {z, y, -x}, {x, -z, y}, {-x, -z, -y}].map do |p|
    rotate(p)
  end.flatten
end

scanners = STDIN.gets_to_end.strip
  .split(/--- scanner \d+ ---/)[1..]
  .map(&.strip.split "\n")
  .map { |s| s.map { |l| Point.from(l.split(",").map(&.to_i)) } }
scanners = scanners.map { |bs| bs.map { |b| rotations(b) }.transpose }
paired = [{scanners.shift.first,{0,0,0}}]
until scanners.empty?
  scanners.each do |s|
    paired.each do |pr,_|
      p = paired? pr, s
      if p
        paired += [p]
        scanners.delete(s)
        break
      end
    end
  end
end
paired.map(&.last).combinations(2).each do |(a,b)|
  f = (0..2).map{|i| b[i]-a[i]}.sum.abs
  puts "#{a} => #{b} = #{f}"
end
