func decode_pattern_id(from pattern: String) -> Int {
    var id = 0
    for letter in pattern {
        let bit = letter.asciiValue! - Character("a").asciiValue!
        id += 1 << bit
    }
    return id
}

func count_common_segments(_ lhs: Int, _ rhs: Int) -> Int {
    var common_segments = 0
    for bit in 0...6 {
        if (lhs & rhs) & (1 << bit) != 0 {
            common_segments += 1
        }
    }
    return common_segments
}

func decode_output_value(from line: String) -> Int {
    let entry_pieces = line.split(separator: "|")

    let input_patterns = entry_pieces[0].split(separator: " ")
    let output_patterns = entry_pieces[1].split(separator: " ")

    var digit_ids = [Int](repeating: 0, count: 10)

    for pattern in input_patterns {
        let id = decode_pattern_id(from: String(pattern))

        switch pattern.count {
        case 2:
            digit_ids[1] = id
        case 3:
            digit_ids[7] = id
        case 4:
            digit_ids[4] = id
        case 7:
            digit_ids[8] = id
        default:
            break
        }
    }

    for pattern in input_patterns {
        let id = decode_pattern_id(from: String(pattern))

        switch pattern.count {
        case 5:
            if count_common_segments(id, digit_ids[4]) == 2 {
                digit_ids[2] = id
            } else if count_common_segments(id, digit_ids[1]) == 2 {
                digit_ids[3] = id
            } else {
                digit_ids[5] = id
            }
        case 6:
            if count_common_segments(id, digit_ids[1]) == 1 {
                digit_ids[6] = id
            } else if count_common_segments(id, digit_ids[4]) == 4 {
                digit_ids[9] = id
            } else {
                digit_ids[0] = id
            }
        default:
            break
        }
    }

    var output_value = 0
    for pattern in output_patterns {
        let id = decode_pattern_id(from: String(pattern))

        var digit: Int?
        for i in 0...9 {
            if digit_ids[i] == id {
                digit = i
                break
            }
        }

        output_value *= 10
        output_value += digit!
    }

    return output_value
}

var outputs_sum = 0
while let line = readLine() {
    outputs_sum += decode_output_value(from: line)
}

print("Sum of all output values is \(outputs_sum)")
