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

maxes = (0..xrange.max).map do |x|
  y_max = 0
  yrange.map(&.abs).max.times do |y|
    next unless enters(x, y, xrange, yrange)
    new_y_max = (y + 1).times.sum
    break y_max if new_y_max < y_max
    y_max = new_y_max
  end
  y_max
end
puts maxes.max
