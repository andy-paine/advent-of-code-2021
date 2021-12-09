input = STDIN.gets_to_end.strip.split("\n").map(&.split(" -> ")).map { |s| s.map { |c| Tuple(Int32, Int32).from(c.split(",").map(&.to_i)) } }
points = input.reduce(input.flatten) do |points, (s, e)|
  vec = {e[0] - s[0], e[1] - s[1]}
  size = vec.map(&.abs).max
  nvec = vec.map { |c| (c/size).to_i }
  points.concat((1...size).map { |i| {s[0] + i*nvec[0], s[1] + i*nvec[1]} })
end
puts points.tally.select { |_, v| v > 1 }.size
