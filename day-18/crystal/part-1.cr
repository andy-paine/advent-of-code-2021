class PInt
  property value : Int32
  property parent : Pair | Nil

  def initialize(@value, @parent = nil); end

  def children(d); nil end

  def to_s
    value.to_s
  end

  def magnitude; value end
end

class Pair
  property left : PInt | Pair
  property right : PInt | Pair
  property parent : Pair | Nil

  def initialize(@left, @right, @parent = nil)
    @left.parent = self
    @right.parent = self
  end

  def children(d) : Array(Tuple(Int32, Pair | PInt))
    [{d, left}, {d, right}, left.try(&.children d + 1), right.try(&.children d + 1)].flatten.compact
  end

  def first_big_value
    return left if left.as?(PInt).try{|x| x.value > 9}
    l = left.as?(Pair).try(&.first_big_value)
    return l if l
    return right if right.as?(PInt).try{|x| x.value > 9}
    r = right.as?(Pair).try(&.first_big_value)
    return r if r
    nil
  end

  def magnitude
    3*left.magnitude + 2*right.magnitude
  end

  def to_s
    "[#{left.to_s},#{right.to_s}]"
  end
end

def split_input(s) : Tuple(String, String)
  left, right = /\[(\d+|(?R)),(\d+|(?R))\]/.match(s).not_nil!.captures.first(2).map(&.not_nil!)
  {left, right}
end

def parse(s : String) : PInt | Pair
  return PInt.new(s.to_i) if s.to_i?
  elems = split_input(s)
  Pair.new(parse(elems.first), parse(elems.last))
end

def explodable?(depth, node)
  node = node.as?(Pair)
  return false unless node
  depth >= 4 && node.left.as?(PInt) && node.right.as?(PInt)
end

def next_r(p : Pair) : PInt | Nil
  until p.parent.nil? || p != p.parent.not_nil!.right
    p = p.parent.not_nil!
  end
  return nil if p.parent.nil?
  node = p.parent.not_nil!.right
  until node.as?(PInt)
    node = node.as(Pair).left
  end
  node.as(PInt)
end

def next_l(p : Pair) : PInt | Nil
  until p.parent.nil? || p != p.parent.not_nil!.left
    p = p.parent.not_nil!
  end
  return nil if p.parent.nil?
  node = p.parent.not_nil!.left
  until node.as?(PInt)
    node = node.as(Pair).right
  end
  node.as(PInt)
end

def explode(p : Pair) : Bool
  node = p.children(1).select { |n| explodable? *n }.map(&.last.as(Pair)).first?
  return false unless node
  nr = next_r(node)
  nl = next_l(node)
  nr.value += node.right.as(PInt).value if nr
  nl.value += node.left.as(PInt).value if nl
  new_node = PInt.new(0, node.parent)
  node.parent.not_nil!.right = new_node if node.parent.not_nil!.right == node
  node.parent.not_nil!.left = new_node if node.parent.not_nil!.left == node
  true
end

def split(p : Pair) : Bool
	node = p.first_big_value
  return false unless node
  split_val = node.as(PInt).value/2
  new_node = Pair.new(PInt.new(split_val.floor.to_i), PInt.new(split_val.ceil.to_i), node.parent)
  node.parent.not_nil!.right = new_node if node.parent.not_nil!.right == node
  node.parent.not_nil!.left = new_node if node.parent.not_nil!.left == node
  true
end

def reduce(p)
  acted = true
  while acted
    acted = explode(p)
    next if acted
    acted = split(p)
  end
end

lines = STDIN.gets_to_end.strip.split("\n")
p = lines[1..].reduce(parse(lines.first).as(Pair)) do |p, n|
  p = Pair.new(p, parse(n))
  reduce(p)
  p
end

puts p.magnitude

