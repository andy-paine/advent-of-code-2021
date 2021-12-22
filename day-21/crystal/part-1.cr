players = STDIN.gets_to_end.strip.split("\n")
  .map { |l| /Player [12] starting position: (\d+)/.match(l).not_nil!.captures }
  .map { |c| {(1..10).to_a.rotate(c.first.not_nil!.to_i - 1), 0} }

dice = (1..100).to_a
score = (1..).each.reduce(players) do |play, turn|
  move = dice.rotate!(3).last(3).sum
  new_score = play.first.last + play.first.first.rotate!(move).first
  break play.last.last * 3 * turn if new_score >= 1000
  [play.last, {play.first.first, new_score}]
end
puts score
