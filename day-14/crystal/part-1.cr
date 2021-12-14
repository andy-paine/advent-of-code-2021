polymer, steps = STDIN.gets_to_end.strip.split("\n\n")
steps = steps.split("\n").map(&.split " -> ").map { |(k, v)| {k, [k[0], v, k[1]].join} }.to_h

def seq(str, steps, len) : String
  unless steps.has_key? str
    subs = str.chars.each.cons(len - 1).map(&.join).map { |x| seq(x, steps, x.size) }.to_a
    steps[str] = ([subs.first] + subs[1..].map(&.[-2..])).join
  end
  steps[str]
end

10.times { polymer = seq(polymer, steps, polymer.size) }
minmax = polymer.chars.tally.values.minmax
puts minmax.last - minmax.first
