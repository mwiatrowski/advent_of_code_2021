let ASCII_0: UInt8 = 48
let ASCII_A: UInt8 = 65

func text_to_bits(_ text: String) -> [UInt8] {
    var bits: [UInt8] = []
    let bytes = [UInt8](text.utf8)
    for byte in bytes {
        var value: UInt8
        if byte >= ASCII_0 && byte <= ASCII_0 + 9 {
            value = byte - ASCII_0
        } else {
            value = 10 + byte - ASCII_A
        }
        for bit_i in (0...3).reversed() {
            let bit = (value & (1 << bit_i) == 0) ? 0 : 1
            bits.append(UInt8(bit))
        }
    }
    return bits
}

class BitStream {
    var bits: ArraySlice<UInt8>
    var position: Int

    init(from slice: ArraySlice<UInt8>) {
        bits = slice
        position = slice.startIndex
    }

    convenience init(from array: [UInt8]) {
        self.init(from: ArraySlice<UInt8>(array))
    }

    func read(_ bits_num: Int) -> ArraySlice<UInt8>? {
        let range_end = position + bits_num
        if range_end > bits.endIndex {
            print("Tried to read \(bits_num) bits, but only \(bits_left()) are left")
            return nil
        } else {
            let slice = bits[position..<range_end]
            position = range_end
            return slice
        }
    }

    func bits_left() -> Int {
        return bits.endIndex - position
    }
}

enum Operation: Int {
    case sum = 0
    case product = 1
    case minimum = 2
    case maximum = 3
    case greater_than = 5
    case less_than = 6
    case equal_to = 7
}

enum Packet {
    case operation(Operation, [Packet])
    case literal_value(Int)
}

func parse_number(from bits: ArraySlice<UInt8>) -> Int {
    var value = 0
    for bit in bits {
        value *= 2
        value += Int(bit)
    }
    return value
}

func parse_literal_value(from stream: BitStream) -> Int {
    var value = 0
    while let group = stream.read(5) {
        let value_bits = ArraySlice<UInt8>(group.dropFirst(1))
        let group_value = parse_number(from: value_bits)
        value *= 16
        value += group_value
        if group.first! == 0 {
            break
        }
    }
    return value
}

func parse_subpackets(from stream: BitStream) -> [Packet] {
    let len_type_id = stream.read(1)!.first!
    if len_type_id == 0 {
        let subpackets_len = parse_number(from: stream.read(15)!)
        let subpackets_bits = stream.read(subpackets_len)!
        let subpackets_stream = BitStream(from: subpackets_bits)
        return parse_packets_list(from: subpackets_stream)
    } else {
        let subpackets_num = parse_number(from: stream.read(11)!)
        var subpackets: [Packet] = []
        for _ in 1...subpackets_num {
            subpackets.append(parse_packet(from: stream))
        }
        return subpackets
    }
}

func parse_packet(from stream: BitStream) -> Packet {
    let _ = parse_number(from: stream.read(3)!)
    let type_id = parse_number(from: stream.read(3)!)

    if type_id == 4 {
        let literal_value = parse_literal_value(from: stream)
        return .literal_value(literal_value)
    } else {
        let subpackets = parse_subpackets(from: stream)
        return .operation(Operation(rawValue: type_id)!, subpackets)
    }
}

func parse_packets_list(from stream: BitStream) -> [Packet] {
    var packets: [Packet] = []
    while stream.bits_left() > 0 {
        packets.append(parse_packet(from: stream))
    }
    return packets
}

func parse_transmission(from stream: BitStream) -> Packet {
    let packet = parse_packet(from: stream)
    if stream.bits_left() > 0 {
        let leftovers = stream.read(stream.bits_left())!
        for bit in leftovers {
            if bit != 0 {
                print("Non-zero value in leftover bits!")
            }
        }
    }
    return packet
}

let input_bits = text_to_bits(readLine()!)
let input_stream = BitStream(from: input_bits)
let top_level_packet = parse_transmission(from: input_stream)

func evaluate(_ packet: Packet) -> Int {
    switch packet {
    case let .operation(operation, subpackets):
        let subpackets_values: [Int] = subpackets.map{ evaluate($0) }

        switch operation {
        case .sum:
            var sum = 0
            for value in subpackets_values {
                sum += value
            }
            return sum

        case .product:
            var product = 1
            for value in subpackets_values {
                product *= value
            }
            return product

        case .minimum:
            var minimum = subpackets_values[0]
            for value in subpackets_values.dropFirst(1) {
                minimum = min(minimum, value)
            }
            return minimum

        case .maximum:
            var maximum = subpackets_values[0]
            for value in subpackets_values.dropFirst(1) {
                maximum = max(maximum, value)
            }
            return maximum

        case .greater_than:
            return (subpackets_values[0] > subpackets_values[1]) ? 1 : 0

        case .less_than:
            return (subpackets_values[0] < subpackets_values[1]) ? 1 : 0

        case .equal_to:
            return (subpackets_values[0] == subpackets_values[1]) ? 1 : 0
        }

    case let .literal_value(value):
        return value
    }
}

print("The expression evaluates to \(evaluate(top_level_packet))")
