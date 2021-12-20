def pad(input : Array(Array(Char)), char)
  c, r = input.size, input.first.size
  2.times { input.push([char]*r).unshift([char]*r) }
  2.times { input.map(&.push char).map(&.unshift char) }
  input
end

def adj(input, x, y)
  (-1..1).map { |i| (-1..1).map { |j| input[x + i][y + j] } }.flatten
end

def enhance(input, algo, x, y)
  lookup(algo, adj(input, x, y))
end

def lookup(algo, chars)
  lookup = Int16.new(chars.map { |c| c == '#' ? 1 : 0 }.join, 2)
  algo[lookup]
end

algo, input = STDIN.gets_to_end.strip.split("\n\n", 2)
input = input.split("\n").map(&.chars)

padding_char = '.'
output = [] of Array(Char)
50.times do |i|
  input = pad(input, padding_char)
  output = Array(Array(Char)).new(input.size) { Array(Char).new(input.first.size, algo.chars.first) }
  (1...input.size - 1).each do |x|
    (1...input.first.size - 1).each do |y|
      output[x][y] = enhance(input, algo, x, y)
    end
  end
  padding_char = lookup(algo, [padding_char]*9)
  input = output[1...-1].map(&.[1...-1])
end
# Strip padding
input.each{|l| puts l.join}
puts input.flatten.count(&.== '#')
