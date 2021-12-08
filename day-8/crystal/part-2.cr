lines = STDIN.gets_to_end.strip.split("\n").map{|l| l.split(" | ").map(&.split)}
letters = {0=>"abcefg",1=>"cf",2=>"acdeg",3=>"acdfg",4=>"bcdf",5=>"abdfg",6=>"abdefg",7=>"acf",8=>"abcdefg",9=>"abcdfg"}.invert
def one(line); line.select{|x| x.size == 2}.first; end
def four(line); line.select{|x| x.size == 4}.first; end
def seven(line); line.select{|x| x.size == 3}.first; end
def eight(line); line.select{|x| x.size == 7}.first; end
f = ->(line : Array(String)) {line.join.chars.tally.select{|_,v| v==9}.first.first}
c = ->(line : Array(String)) {one(line).chars.reject(f.call(line)).first}
a = ->(line : Array(String)) {seven(line).chars.reject(f.call(line)).reject(c.call(line)).first}
b = ->(line : Array(String)) {line.join.chars.tally.select{|_,v| v==6}.first.first}
d = ->(line : Array(String)) {(four(line).chars - one(line).chars).reject(b.call(line)).first}
e = ->(line : Array(String)) {line.join.chars.tally.select{|_,v| v==4}.first.first}
g = ->(line : Array(String)) {line.join.chars.tally.select{|_,v| v==7}.reject(four(line).chars).first.first}
convert = {'a'=>a, 'b'=>b, 'c'=>c, 'd'=>d, 'e'=>e, 'f'=>f, 'g'=>g}
nums = lines.map do |l|
  mapping = "abcdefg".chars.map{|c| [convert[c].call(l.first),c]}.to_h
  l.last.map{|s| s.chars.map{|c| mapping[c]}.sort.join}.map{|n| letters[n]}.join.to_i
end
puts nums.sum
