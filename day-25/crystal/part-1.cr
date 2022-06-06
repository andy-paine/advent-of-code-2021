alias Coord = Tuple(Int32, Int32)

def find(cucumbers, typ : Char) Array(Coord)
  cucumbers.map_with_index do |row,x|
    row.map_with_index do |c, y|
      {x,y} if c == typ
    end
  end.flatten.compact
end

cucumbers = STDIN.gets_to_end.strip.split("\n").map(&.chars)
num = (1..).each do |i|
  ds = find(cucumbers, '>').select{|d| cucumbers[d.first][(d.last+1)%cucumbers.first.size] == '.'}
  ds.each do |d|
    cucumbers[d.first][d.last] = '.'
    cucumbers[d.first][(d.last+1)%cucumbers.first.size] = '>'
  end
  vs = find(cucumbers, 'v').select{|v| cucumbers[(v.first+1)%cucumbers.size][v.last] == '.'}
  vs.each do |v|
    cucumbers[v.first][v.last] = '.'
    cucumbers[(v.first+1)%cucumbers.size][v.last] = 'v'
  end
  break i if ds.empty? && vs.empty?
end.not_nil!

puts num
