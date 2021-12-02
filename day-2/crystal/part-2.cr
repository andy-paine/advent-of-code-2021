def apply(acc, dir, amount)
  case dir
  when "down"
  {acc[0]+amount, acc[1], acc[2]}
  when "up"
  {acc[0]-amount, acc[1], acc[2]}
  when "forward"
  {acc[0], acc[1]+(acc[0]*amount), acc[2]+amount}
  end
end

x = STDIN.gets_to_end.strip.split("\n").map{|s| s.split}.reduce({0,0,0}) { |acc,s| apply(acc.not_nil!,s[0],s[1].to_i) }
puts "#{x.not_nil![1] * x.not_nil![2]}"
