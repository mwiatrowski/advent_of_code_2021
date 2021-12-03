let ASCII_ZERO: Int = 48

var line_length: Int? = nil
var number_of_lines = 0
var ones_count: [Int] = []

while let line = readLine() {
    number_of_lines += 1

    if line_length == nil {
        line_length = line.count
        ones_count = [Int](repeating: 0, count: line_length!)
    }

    for (i, character) in line.enumerated() {
        let digit = Int(character.asciiValue!) - ASCII_ZERO
        ones_count[i] += digit
    }
}

var gamma: Int = 0
var epsilon: Int = 0

for i in 0..<line_length! {
    gamma *= 2
    epsilon *= 2

    if ones_count[i] > (number_of_lines / 2) {
        gamma += 1
    } else {
        epsilon += 1
    }
}

print("Gamma rate: \(gamma), epsilon rate: \(epsilon)")
print("Power consumption: \(gamma * epsilon)")
