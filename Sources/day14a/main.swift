let CYCLES = 10

let ASCII_A = 65
let ASCII_Z = 90
let LETTERS_COUNT = 1 + ASCII_Z - ASCII_A

let polymer_template: [Int] = [UInt8](readLine()!.utf8).map{ Int($0) - ASCII_A }

_ = readLine()

var insertions: [[Int?]] = []
for _ in 1...LETTERS_COUNT {
    insertions.append([Int?](repeating: nil, count: LETTERS_COUNT))
}

while let line = readLine() {
    let bytes: [Int] = [UInt8](line.utf8).map{ Int($0) }
    let index1 = bytes[0] - ASCII_A
    let index2 = bytes[1] - ASCII_A
    insertions[index1][index2] = bytes[6] - ASCII_A
}

var pairs: [(Int, Int)] =
    zip(polymer_template, polymer_template.dropFirst(1))
    .map{ ($0, $1) }

func run_cycle(on input_pairs: [(Int, Int)]) -> [(Int, Int)] {
    var output_pairs: [(Int, Int)] = []
    for (letter1, letter2) in input_pairs {
        if let new_letter = insertions[letter1][letter2] {
            output_pairs.append((letter1, new_letter))
            output_pairs.append((new_letter, letter2))
        } else {
            output_pairs.append((letter1, letter2))
        }
    }
    return output_pairs
}

for _ in 1...CYCLES {
    pairs = run_cycle(on: pairs)
}

var letter_count_doubled = [Int](repeating: 0, count: LETTERS_COUNT)
letter_count_doubled[polymer_template.first!] += 1
letter_count_doubled[polymer_template.last!] += 1
for (letter1, letter2) in pairs {
    letter_count_doubled[letter1] += 1
    letter_count_doubled[letter2] += 1
}

let positive_letter_counts = letter_count_doubled.filter{ $0 > 0 }.map{ $0 / 2 }
let min_count = positive_letter_counts.min()!
let max_count = positive_letter_counts.max()!

print("Difference in quantity between the most and the least common elements is equal to \(max_count - min_count)")
