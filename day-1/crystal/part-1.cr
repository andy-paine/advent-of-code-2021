puts "#{STDIN.gets_to_end.strip.split("\n").each.cons(2).select{ |elems| elems[-1].to_i > elems[0].to_i}.size}"
