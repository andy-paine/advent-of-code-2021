record Packet, version : Int64, literal : Int64, packets : Array(Packet), leftover : Array(Char)

def packet(pkt) : Packet
  version = Int64.new(pkt.shift(3).join, 2)
  type_id = Int64.new(pkt.shift(3).join, 2)
  if type_id == 4
    digit = ""
    while true
      p = pkt.shift(5)
      digit += p.last(4).join
      break if p.first == '0'
    end
    return Packet.new(version, Int64.new(digit, 2), [] of Packet, pkt)
  else
    l_type_id = pkt.shift
    if l_type_id == '0'
      next_packet_count = Int64.new(pkt.shift(15).join, 2)
      next_pkt = packet(pkt.shift(next_packet_count))
      packets = [next_pkt]
      while !packets.last.not_nil!.leftover.all?(&.== '0')
        packets.push packet(packets.last.leftover)
      end
      return Packet.new(version, 0, packets, pkt)
    else
      num_packets = Int64.new(pkt.shift(11).join, 2)
      packets = num_packets.times.map do
				pkt
        next_pkt = packet(pkt)
        pkt = next_pkt.leftover
        next_pkt
      end
      return Packet.new(version, 0, packets.to_a, pkt)
    end
  end
end

def versions(pkt : Packet) : Int64
  pkt.version + pkt.packets.map { |p| versions(p) }.sum
end

bin = STDIN.gets_to_end.strip.chars.map { |c| Int64.new(c.to_s, 16).to_s(2).rjust(4, '0') }.flatten.join
puts versions(packet(bin.chars))
