ranges = STDIN.gets_to_end.strip.match(/target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/).not_nil!.captures

xrange = (ranges[0].not_nil!.to_i..ranges[1].not_nil!.to_i)
yrange =	(ranges[2].not_nil!.to_i..ranges[3].not_nil!.to_i)

def enters(x, y, xrange, yrange)
  pos = {0, 0}
  while true
    pos = {pos.first + x, pos.last + y}
    x = x - (x/x.abs).to_i unless x.zero?
    y -= 1
    break if pos.first > xrange.max
    break if pos.last < yrange.min && y.negative?
    return true if xrange.includes?(pos.first) && yrange.includes?(pos.last)
  end
  false
end

y_max = yrange.map(&.abs).max
points = (0..xrange.max).map do |x|
  (-1*y_max..y_max)
    .select { |y| enters(x, y, xrange, yrange) }
    .map { |y| {x, y} }
end.flatten
puts points.size
