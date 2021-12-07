fish = STDIN.gets_to_end.strip.split(",").map(&.to_i)
def produced(fish)
  return 0 if !fish.negative?
  direct = (fish/7).abs.ceil.to_i
  direct + direct.times.map{|i| produced(fish+9+i*7)}.sum
end
puts fish.map{|f| produced(f-80)+1}.sum
