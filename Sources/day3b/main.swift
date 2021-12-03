var number_of_bits: Int? = nil
var values: [Int] = []

while let line = readLine() {
    if number_of_bits == nil {
        number_of_bits = line.count
    }

    var value: Int = 0
    for character in line {
        value *= 2
        if character == "1" {
            value += 1
        }
    }
    values.append(value)
}

var oxygen_values: [Int] = values
for bit_pos in 1...number_of_bits! {
    let mask = (1 << (number_of_bits! - bit_pos))

    var ones_count = 0
    for value in oxygen_values {
        if value & mask != 0 {
            ones_count += 1
        }
    }

    if (2 * ones_count) >= oxygen_values.count {
        oxygen_values = oxygen_values.filter { $0 & mask != 0 }
    } else {
        oxygen_values = oxygen_values.filter { $0 & mask == 0 }
    }

    if oxygen_values.count == 1 {
        break
    }
}
let oxygen = oxygen_values[0]

var co2_values: [Int] = values
for bit_pos in 1...number_of_bits! {
    let mask = (1 << (number_of_bits! - bit_pos))

    var zeroes_count = 0
    for value in co2_values {
        if value & mask == 0 {
            zeroes_count += 1
        }
    }

    if (2 * zeroes_count) <= co2_values.count {
        co2_values = co2_values.filter { $0 & mask == 0 }
    } else {
        co2_values = co2_values.filter { $0 & mask != 0 }
    }

    if co2_values.count == 1 {
        break
    }
}
let co2 = co2_values[0]

print("Oxygen generator rating: \(oxygen), CO2 scrubber rating: \(co2)")
print("Life support rating: \(oxygen * co2)")
