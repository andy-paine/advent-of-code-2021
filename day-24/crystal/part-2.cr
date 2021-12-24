alias Op = Proc(Hash(String, Int64), String, String, Nil)

OPS = {
  "inp" => Op.new { |reg, a, b| reg[a] = b.to_i64 },
  "add" => Op.new { |reg, a, b| reg[a] = reg[a] + reg.fetch(b){|b| b.to_i64} },
  "mul" => Op.new { |reg, a, b| reg[a] = reg[a] * reg.fetch(b){|b| b.to_i64} },
  "div" => Op.new { |reg, a, b| x = reg[a]/reg.fetch(b){|b| b.to_i64}; reg[a] = x > 0 ? x.floor.to_i64 : x.ceil.to_i64 },
  "mod" => Op.new { |reg, a, b| reg[a] = reg[a] % reg.fetch(b){|b| b.to_i64} },
  "eql" => Op.new { |reg, a, b| reg[a] = reg[a] == reg.fetch(b){|b| b.to_i64} ? 1_i64 : 0_i64 },
}

ins = STDIN.gets_to_end.strip

blocks = 14.times.map do
  i_prev, i, i_last = ins.rpartition(/inp [wxyz]/)
  ins = i_prev
	[i,i_last].join.strip.split("\n")
end.to_a.reverse

def process(block, register, input)
  op, a = block.first.split
  OPS[op].call register, a, input.to_s
  block[1..].each do |ins|
    op, a, b = ins.split
    OPS[op].call register, a, b
  end
  register
end

zs = {0_i64 => ""}
blocks.each_with_index do |b,bi|
  nzs = {} of Int64 => Int64
  (1..9).each do |i|
    zs.each do |z,k|
      val = (k.to_s + i.to_s).to_i64
      nz = process(b, {"x"=>0_i64,"y"=>0_i64,"z"=>z}, i.to_i64)["z"]
      nzs[nz] = val if val < nzs.fetch(nz, Int64::MAX)
    end
  end
  puts "Found #{nzs.size} states for step #{bi}"
  zs = nzs
end
puts "Solution: #{zs[0_i64]}"
