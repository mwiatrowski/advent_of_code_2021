enum Command {
    case Forward
    case Down
    case Up
}

func parse_input_line(line: String) -> (command: Command, amount: Int)? {
    let tokens = line.split(separator: " ")
    if tokens.count != 2 {
        return nil
    }
    if let amount = Int(tokens[1]) {
        var command: Command;
        switch tokens[0] {
        case "forward":
            command = Command.Forward
        case "down":
            command = Command.Down
        case "up":
            command = Command.Up
        default:
            return nil
        }
        return (command, amount)
    } else {
        return nil
    }
}

var horizontal_pos: Int = 0
var depth: Int = 0
var aim: Int = 0

while let line = readLine() {
    if let (command, amount) = parse_input_line(line: line) {
        switch command {
        case Command.Forward:
            horizontal_pos += amount
            depth += aim * amount
        case Command.Down:
            aim += amount
        case Command.Up:
            aim -= amount
        }
    } else {
        print("Error on input line: \(line)")
    }
}

print("Horizontal position: \(horizontal_pos), depth: \(depth)")
print("Product of coordinates: \(horizontal_pos * depth)")
