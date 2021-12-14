let CYCLES = 40

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

var pair_count: [[Int64]] = []
for _ in 1...LETTERS_COUNT {
    pair_count.append([Int64](repeating: 0, count: LETTERS_COUNT))
}

for (letter1, letter2) in zip(polymer_template, polymer_template.dropFirst(1)) {
    pair_count[letter1][letter2] += 1
}

func run_cycle(on input_pairs: [[Int64]]) -> [[Int64]] {
    var output_pairs: [[Int64]] = []
    for _ in 1...LETTERS_COUNT {
        output_pairs.append([Int64](repeating: 0, count: LETTERS_COUNT))
    }

    for letter1 in 0..<LETTERS_COUNT {
        for letter2 in 0..<LETTERS_COUNT {
            let count = input_pairs[letter1][letter2]
            if let new_letter = insertions[letter1][letter2] {
                output_pairs[letter1][new_letter] += count
                output_pairs[new_letter][letter2] += count
            } else {
                output_pairs[letter1][letter2] += count
            }
        }
    }

    return output_pairs
}

for _ in 1...CYCLES {
    pair_count = run_cycle(on: pair_count)
}

var letter_count_doubled = [Int64](repeating: 0, count: LETTERS_COUNT)
letter_count_doubled[polymer_template.first!] += 1
letter_count_doubled[polymer_template.last!] += 1
for letter1 in 0..<LETTERS_COUNT {
    for letter2 in 0..<LETTERS_COUNT {
        let count = pair_count[letter1][letter2]
        letter_count_doubled[letter1] += count
        letter_count_doubled[letter2] += count
    }
}

let positive_letter_counts = letter_count_doubled.filter{ $0 > 0 }.map{ $0 / 2 }
let min_count = positive_letter_counts.min()!
let max_count = positive_letter_counts.max()!

print("Difference in quantity between the most and the least common elements is equal to \(max_count - min_count)")
