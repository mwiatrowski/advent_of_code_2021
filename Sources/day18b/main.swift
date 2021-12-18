let ASCII_ZERO: UInt8 = Character("0").asciiValue!
let ASCII_COMMA: UInt8 = Character(",").asciiValue!
let ASCII_LBR: UInt8 = Character("[").asciiValue!
let ASCII_RBR: UInt8 = Character("]").asciiValue!

class ByteStream {
    var bytes: [UInt8]
    var position: Int

    init(from array: [UInt8]) {
        bytes = array
        position = 0
    }

    func peek() -> UInt8? {
        if position >= bytes.count {
            return nil
        } else {
            return bytes[position]
        }
    }

    func get() -> UInt8? {
        let byte = peek()
        position += 1
        return byte
    }

    func expect(_ value: UInt8) {
        let byte = get()
        if byte != value {
            print("Expected \(Character(UnicodeScalar(value)))!")
        }
    }
}

enum SnailfishValue {
    case literal(Int)
    case pair(SnailfishNumber, SnailfishNumber)
}

class SnailfishNumber {
    var value: SnailfishValue
    weak var parent: SnailfishNumber?

    init(_ value: SnailfishValue, parent: SnailfishNumber?) {
        self.value = value
        self.parent = parent
    }

    func copy() -> SnailfishNumber {
        switch value {
        case let .literal(value):
            return SnailfishNumber(.literal(value), parent: nil)
        case let .pair(left, right):
            let left_copy = left.copy()
            let right_copy = right.copy()
            let my_copy = SnailfishNumber(.pair(left_copy, right_copy), parent: nil)
            left_copy.parent = my_copy
            right_copy.parent = my_copy
            return my_copy
        }
    }
}

func byte_to_digit(from byte: UInt8) -> Int? {
    if byte >= ASCII_ZERO && byte <= ASCII_ZERO + 9 {
        return Int(byte - ASCII_ZERO)
    } else {
        return nil
    }
}

func parse_pair(from stream: ByteStream) -> SnailfishNumber {
    stream.expect(ASCII_LBR)
    let left = parse_snailfish_number(from: stream)
    stream.expect(ASCII_COMMA)
    let right = parse_snailfish_number(from: stream)
    stream.expect(ASCII_RBR)

    let number = SnailfishNumber(.pair(left, right), parent: nil)
    left.parent = number
    right.parent = number
    return number
}

func parse_snailfish_number(from stream: ByteStream) -> SnailfishNumber {
    let next_byte = stream.peek()!
    if let digit = byte_to_digit(from: next_byte) {
        _ = stream.get()
        return SnailfishNumber(.literal(digit), parent: nil)
    } else {
        return parse_pair(from: stream)
    }
}

func leftmost_literal(of number: SnailfishNumber) -> SnailfishNumber {
    switch number.value {
    case .literal:
        return number
    case let .pair(left, _):
        return leftmost_literal(of: left)
    }
}

func rightmost_literal(of number: SnailfishNumber) -> SnailfishNumber {
    switch number.value {
    case .literal:
        return number
    case let .pair(_, right):
        return rightmost_literal(of: right)
    }
}

func immediate_left_literal(of number: SnailfishNumber) -> SnailfishNumber? {
    if let parent = number.parent {
        switch parent.value {
        case .literal:
            print("Not a proper tree!")
        case let .pair(left, _):
            if number === left {
                return immediate_left_literal(of: parent)
            } else {
                return rightmost_literal(of: left)
            }
        }
    }
    return nil
}

func immediate_right_literal(of number: SnailfishNumber) -> SnailfishNumber? {
    if let parent = number.parent {
        switch parent.value {
        case .literal:
            print("Not a proper tree!")
        case let .pair(_, right):
            if number === right {
                return immediate_right_literal(of: parent)
            } else {
                return leftmost_literal(of: right)
            }
        }
    }
    return nil
}

func explode_pair(_ number: SnailfishNumber) {
    if case let .pair(left, right) = number.value {
        if case let .literal(lit_left) = left.value, case let .literal(lit_right) = right.value {
            if let num_left = immediate_left_literal(of: number) {
                if case let .literal(old_value) = num_left.value {
                    num_left.value = .literal(old_value + lit_left)
                } else {
                    print("Immediate left literal is not a literal")
                }
            }
            if let num_right = immediate_right_literal(of: number) {
                if case let .literal(old_value) = num_right.value {
                    num_right.value = .literal(old_value + lit_right)
                } else {
                    print("Immediate right literal is not a literal")
                }
            }
        } else {
            print("Exploded pair is nested!")
        }
    } else {
        print("Exploded number is not a pair!")
    }

    let new_number = SnailfishNumber(.literal(0), parent: number.parent)

    if let parent = number.parent {
        switch parent.value {
        case .literal:
            print("Not a proper tree!")
        case let .pair(left, right):
            if number === left {
                parent.value = .pair(new_number, right)
            } else if (number === right) {
                parent.value = .pair(left, new_number)
            } else {
                print("Assumed parent was not actually a parent!")
            }
        }
    } else {
        print("Exploded pair must have a parent!")
    }
}

func find_deep_pair(_ number: SnailfishNumber, depth: Int) -> SnailfishNumber? {
    switch number.value {
    case .literal:
        return nil
    case let .pair(left, right):
        if case .literal = left.value, case .literal = right.value {
            return depth > 4 ? number : nil
        }
        if let deep_num = find_deep_pair(left, depth: depth + 1) {
            return deep_num
        }
        if let deep_num = find_deep_pair(right, depth: depth + 1) {
            return deep_num
        }
        return nil
    }
}

func try_explode(_ number: SnailfishNumber) -> Bool {
    if let deep_pair = find_deep_pair(number, depth: 1) {
        explode_pair(deep_pair)
        return true
    } else {
        return false
    }
}

func split_literal(_ number: SnailfishNumber) {
    if case let .literal(value) = number.value {
        if value > 9 {
            let left = SnailfishNumber(.literal(value / 2), parent: nil)
            let right = SnailfishNumber(.literal((value + 1) / 2), parent: nil)
            let new_number = SnailfishNumber(.pair(left, right), parent: number.parent)
            left.parent = new_number
            right.parent = new_number

            if let parent = number.parent {
                if case let .pair(left, right) = parent.value {
                    if left === number {
                        parent.value = .pair(new_number, right)
                    } else if right === number {
                        parent.value = .pair(left, new_number)
                    } else {
                        print("Assumed parent was not actually a parent!")
                    }
                } else {
                    print("Not a proper tree!")
                }
            }
        } else {
            print("Value is not high enough to be split!")
        }
    } else {
        print("Split number must be a literal!")
    }
}

func find_large_literal(_ number: SnailfishNumber) -> SnailfishNumber? {
    switch number.value {
    case let .literal(value):
        return (value > 9) ? number : nil
    case let .pair(left, right):
        if let large_literal = find_large_literal(left) {
            return large_literal
        }
        if let large_literal = find_large_literal(right) {
            return large_literal
        }
        return nil
    }
}

func try_split(_ number: SnailfishNumber) -> Bool {
    if let large_literal = find_large_literal(number) {
        split_literal(large_literal)
        return true
    } else {
        return false
    }
}

func add(_ lhs: SnailfishNumber, _ rhs: SnailfishNumber) -> SnailfishNumber {
    let lhs_copy = lhs.copy()
    let rhs_copy = rhs.copy()
    let sum = SnailfishNumber(.pair(lhs_copy, rhs_copy), parent: nil)
    lhs_copy.parent = sum
    rhs_copy.parent = sum

    while true {
        if try_explode(sum) {
            continue
        }
        if try_split(sum) {
            continue
        }
        break
    }

    return sum
}

func magnitude(_ number: SnailfishNumber) -> Int {
    switch number.value {
    case let .literal(value):
        return value
    case let .pair(left, right):
        return 3 * magnitude(left) + 2 * magnitude(right)
    }
}

var numbers: [SnailfishNumber] = []
while let line = readLine() {
    let bytes = [UInt8](line.utf8)
    let stream = ByteStream(from: bytes)
    let number = parse_snailfish_number(from: stream)
    numbers.append(number)
}

var max_magnitude = 0
for i in 0..<numbers.count {
    for j in 0..<numbers.count {
        if i == j {
            continue
        }
        let sum = add(numbers[i], numbers[j])
        max_magnitude = max(max_magnitude, magnitude(sum))
    }
}

print("Magnitude of the largest sum is equal to \(max_magnitude)")
