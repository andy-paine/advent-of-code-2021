lines = STDIN.gets_to_end.strip.split("\n").map { |l| l.chars.map(&.to_i) }

def filter(lines, op)
  lines.first.size.times.reduce(lines) do |lines, i|
    break lines if lines.size == 1
    lines.select { |l| l[i] == op.call(lines.map { |l| l[i] }.tally.invert).last }
  end.first
end

ox = filter(lines, ->(x : Hash(Int32, Int32)) { x.max })
co = filter(lines, ->(x : Hash(Int32, Int32)) { x.min })
puts Int32.new(ox.join, 2) * Int32.new(co.join, 2)
