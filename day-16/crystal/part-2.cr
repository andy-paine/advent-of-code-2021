record Packet, version : Int32, type_id : Int8, literal : Int64, packets : Array(Packet), leftover : Array(Char)

def packet(pkt) : Packet
  version = Int32.new(pkt.shift(3).join, 2)
  type_id = Int8.new(pkt.shift(3).join, 2)
  if type_id == 4
    digit = ""
    while true
      p = pkt.shift(5)
      digit += p.last(4).join
      break if p.first == '0'
    end
    return Packet.new(version, type_id, Int64.new(digit, 2), [] of Packet, pkt)
  else
    l_type_id = pkt.shift
    if l_type_id == '0'
      next_packet_count = Int32.new(pkt.shift(15).join, 2)
      next_pkt = packet(pkt.shift(next_packet_count))
      packets = [next_pkt]
      while !packets.last.not_nil!.leftover.all?(&.== '0')
        packets.push packet(packets.last.leftover)
      end
      return Packet.new(version, type_id, 0, packets, pkt)
    else
      num_packets = Int32.new(pkt.shift(11).join, 2)
      packets = num_packets.times.map do
        pkt
        next_pkt = packet(pkt)
        pkt = next_pkt.leftover
        next_pkt
      end
      return Packet.new(version, type_id, 0, packets.to_a, pkt)
    end
  end
end

def calculate(pkt : Packet) : Int64
  val = case pkt.type_id
  when 4
    pkt.literal
  when 0
    pkt.packets.map { |p| calculate(p) }.sum
  when 1
    pkt.packets.map { |p| calculate(p) }.product
  when 2
    pkt.packets.map { |p| calculate(p) }.min
  when 3
    pkt.packets.map { |p| calculate(p) }.max
  when 5
    calculate(pkt.packets[0]) > calculate(pkt.packets[1]) ? 1 : 0
  when 6
    calculate(pkt.packets[0]) < calculate(pkt.packets[1]) ? 1 : 0
  when 7
    calculate(pkt.packets[0]) == calculate(pkt.packets[1]) ? 1 : 0
  else
    0
  end
  val.to_i64
end

bin = STDIN.gets_to_end.strip.chars.map { |c| Int64.new(c.to_s, 16).to_s(2).rjust(4, '0') }.flatten.join
puts calculate(packet(bin.chars))
