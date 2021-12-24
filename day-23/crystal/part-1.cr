alias Position = Tuple(Char, Int32)
alias Positions = Hash(Char, Array(Char))

ALL_MOVES = "ABCD".chars.map { |c| [0, 1].map { |i| {c, i} } }.flatten + 11.times.map { |i| {'H', i} }.to_a

def parse(input) : Positions
  lines = input.split("\n")[1..3]
  positions = {'H' => lines.shift.chars.reject('#')}
  holes = lines.map { |l| l.chars.select { |c| "ABCD.".includes? c } }

  holes
    .transpose
    .each_with_index { |hs, i| positions["ABCD".chars[i]] = hs.reverse }

  positions
end

def to_s(p : Positions) : String
  [
    "#############",
    "#" + p['H'].join + "#",
    "###" + "ABCD".chars.map { |c| p[c][1] }.join('#') + "###",
    "  #" + "ABCD".chars.map { |c| p[c][0] }.join('#') + "#  ",
    "  #########  ",
  ].join "\n"
end

def valid_move?(from : Position, to : Position, positions : Positions) : Bool
  return false unless positions[to.first][to.last] == '.'
  return false unless from.first == 'H' || to.first == 'H'
  a = positions[from.first][from.last]
  # Don't move out of the correct hole
  return false if from == {a, 0}
  if to.first == 'H'
    return false if from.first == 'H'
    return false if [2, 4, 6, 8].includes? to.last
    none_between? from, to, positions
  else
    return false if to.first != a
    return false unless positions[to.first].all? { |c| c == a || c == '.' }
    none_between? from, to, positions
  end
end

def range(a, b)
  b > a ? (a + 1...b) : (b + 1...a)
end

def prefer_deepest!(moves)
  moves.reject! { |(_, _), (c, i)| i == 1 && moves.any? { |_, x| x == {c, 0} } }
  moves.reject! { |(_, _), (c, _)| c == 'H' } if moves.any? { |(_, _), (c, _)| c != 'H' }
end

def none_between?(from : Position, to : Position, positions : Positions) : Bool
  from, to = to, from unless from.first == 'H'
  hole_pos = "ABCD".index(to.first).not_nil! * 2 + 2
  return false unless range(from.last, hole_pos).all? { |i| positions['H'][i] == '.' }
  return false if to.last == 0 && positions[to.first][1] != '.'
  true
end

COSTS    = "ABCD".chars.map_with_index { |c, i| {c, 10**i} }.to_h
FINISHED = "ABCD".chars.map { |c| {c, [c, c]} }.to_h
ROUTE    = {[{ {'X', 0}, {'X', 0}, 'X' }] => Int32::MAX}

def costs(moves)
  moves.map { |m| cost(*m) }.sum
end

def cost(from : Position, to : Position, c : Char)
  Int32
  from, to = to, from unless from.first == 'H'
  hole_pos = "ABCD".index(to.first).not_nil! * 2 + 2
  ((hole_pos - from.last).abs + 1 + (to.last.zero? ? 1 : 0)) * COSTS[c]
end

def organize(positions : Positions, prev_moves : Array(Tuple(Position, Position, Char)))
  prev_score = costs(prev_moves)
  return if prev_score >= ROUTE.values.min
  return ROUTE[prev_moves] = prev_score if positions.select { |k, _| "ABCD".includes? k } == FINISHED
  amphs = ALL_MOVES.select { |c, i| positions[c][i] != '.' }
  moves = amphs.map { |a| ALL_MOVES.select { |to| valid_move? a, to, positions }.map { |m| {a, m} } }.flatten
  prefer_deepest!(moves)
  return if moves.empty?
  moves.sort_by(&.last).each do |from, to|
    c = positions[from.first][from.last]
    next if prev_moves.includes?({to, from, c})
    new_pos = positions.clone
    new_pos[to.first][to.last] = c
    new_pos[from.first][from.last] = '.'
    organize(new_pos, prev_moves + [{from, to, c}])
  end
end

positions = parse(STDIN.gets_to_end.strip)
organize(positions, [] of Tuple(Position, Position, Char))
puts ROUTE.values.min
