input = STDIN.gets_to_end.strip.split("\n\n")
nums = input.shift.split(',').map(&.to_i)
boards = input.map { |b| b.split("\n").map(&.strip).map { |l| l.split.map(&.to_i) } }

def solution(board)
end

solutions = boards.map { |b| b + b.first.size.times.map { |i| b.map { |l| l[i] } }.to_a }
called = nums.take_while do |n|
  solutions.reject! { |s| s.any?(&.empty?) }
  solutions.map! { |s| s.map { |l| l.select { |i| i != n } } }
  !solutions.all? { |s| s.any?(&.empty?) }
end
solutions
remaining = solutions.select { |s| s.any?(&.empty?) }.last.flatten.uniq.sum
puts (nums - called).first * remaining
