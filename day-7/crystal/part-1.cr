pos = STDIN.gets_to_end.strip.split(",").map(&.to_i)
puts pos.max.times.map{|i| pos.map{|p| (p-i).abs}.sum}.min
