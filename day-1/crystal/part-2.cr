puts "#{STDIN.gets_to_end.strip.split("\n").each.cons(4).map{ |elems| elems[-1].to_i > elems[0].to_i ? 1 : 0}.sum}"
