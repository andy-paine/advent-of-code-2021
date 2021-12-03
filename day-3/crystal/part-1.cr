lines = STDIN.gets_to_end.strip.split("\n").map{|l| l.split("").map(&.to_i)}
gamma = Int32.new((lines.first.size).times.map {|x| lines.map{|l| l[x]}.tally.invert.max.last}.join, 2)
epsilon = 2**lines.first.size - 1 - gamma
puts gamma * epsilon
