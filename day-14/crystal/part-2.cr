polymer, steps = STDIN.gets_to_end.strip.split("\n\n")
steps = steps.split("\n")
  .map(&.split " -> ")
  .map { |k| {Tuple(Char, Char).from(k.first.chars), k.last.chars.last} }
  .to_h

pairs = polymer.chars.each.cons_pair.map { |a, b| { {a, b}, 1_i64 } }.to_h
counts = polymer.chars.tally.map { |k, v| {k, v.to_i64} }.to_h

40.times do |i|
  pairs.clone.each do |(a, b), v|
    n = steps[{a, b}]
    pairs[{a, n}] = pairs.fetch({a, n}, 0_i64) + v
    pairs[{n, b}] = pairs.fetch({n, b}, 0_i64) + v
    pairs[{a, b}] = pairs[{a, b}] - v
    counts[n] = counts.fetch(n, 0_i64) + v
  end
end
puts counts.values.max - counts.values.min
