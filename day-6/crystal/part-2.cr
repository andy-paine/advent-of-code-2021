fish = STDIN.gets_to_end.strip.split(",").map(&.to_i)

def produced(fish, memo)
  return memo[fish] if memo.has_key? fish
  return 0.to_i64 if !fish.negative?
  direct = (fish/7).abs.ceil.to_i64
  direct + direct.times.map { |i| produced(fish + 9 + i*7, memo) }.sum
end

prod = (0...257).map { |i| i*-1 }.reduce({} of Int32 => Int64) { |memo, i| memo[i] = produced(i, memo); memo }
puts fish.map { |f| prod[f - 256] + 1 }.sum
