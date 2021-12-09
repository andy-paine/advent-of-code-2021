def amount(vals)
  vals.map { |v| v.split[1].to_i }.sum
end

is = STDIN.gets_to_end.strip.split("\n").group_by { |i| i.split[0] }
puts "#{(amount(is["down"]) - amount(is["up"])) * amount(is["forward"])}"
