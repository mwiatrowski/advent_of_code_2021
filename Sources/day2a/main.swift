enum Direction {
    case Forward
    case Down
    case Up
}

func parse_input_line(line: String) -> (direction: Direction, amount: Int)? {
    let tokens = line.split(separator: " ")
    if tokens.count != 2 {
        return nil
    }
    if let amount = Int(tokens[1]) {
        var direction: Direction;
        switch tokens[0] {
        case "forward":
            direction = Direction.Forward
        case "down":
            direction = Direction.Down
        case "up":
            direction = Direction.Up
        default:
            return nil
        }
        return (direction, amount)
    } else {
        return nil
    }
}

var horizontal_pos: Int = 0
var depth: Int = 0

while let line = readLine() {
    if let (direction, amount) = parse_input_line(line: line) {
        switch direction {
        case Direction.Forward:
            horizontal_pos += amount
        case Direction.Down:
            depth += amount
        case Direction.Up:
            depth -= amount
        }
    } else {
        print("Error on input line: \(line)")
    }
}

print("Horizontal position: \(horizontal_pos), depth: \(depth)")
print("Product of coordinates: \(horizontal_pos * depth)")
