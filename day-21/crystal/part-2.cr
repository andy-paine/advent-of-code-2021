players = STDIN.gets_to_end.strip.split("\n")
  .map { |l| /Player [12] starting position: (\d+)/.match(l).not_nil!.captures }
  .map { |c| {c.first.not_nil!.to_u8, 0_u8} }

alias Player = Tuple(UInt8, UInt8)
ROLLS = (1..3).map { |i| (1..3).map { |j| (1..3).map { |k| {i.to_u8, j.to_u8, k.to_u8} } } }.flatten

class Game
  property wins

  def initialize
    @wins = {} of Tuple(Player, Player, Int32) => Int64
  end

  def play(a : Player, b : Player, roll : UInt8, turn : Int32) : Int64
    pos = (a.first + roll - 1) % 10 + 1
    a = {pos, a.last + pos}
    return turn % 2 == 0 ? 1_i64 : 0_i64 if a.last >= 21
    return @wins[{a, b, turn % 2}] if @wins.has_key?({a, b, turn % 2})
    outcomes = ROLLS.map { |i, j, k| play(b, a, i + j + k, turn + 1) }.sum.to_i64
    @wins[{a, b, turn % 2}] = outcomes
    outcomes
  end
end

g = Game.new
a_result = ROLLS.reduce(0_i64) do |total, (i, j, k)|
  total + g.play(players.first, players.last, i + j + k, 0)
end
b_result = ROLLS.reduce(0_i64) do |total, (i, j, k)|
  total + g.play(players.first,  players.last, i + j + k, 1)
end
puts [a_result, b_result].max
