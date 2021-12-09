let ASCII_ZERO = 48

var map: [[Int]] = []
while let line = readLine() {
    let row: [Int] =
        line.map({ (digit: Character) -> Int in Int(digit.asciiValue!) - ASCII_ZERO })
    map.append(row)
}

let map_width = map[0].count
let map_height = map.count

func get_height(_ row: Int, _ col: Int) -> Int {
    if col < 0 || col >= map_width || row < 0 || row >= map_height {
        return 10
    }
    return map[row][col]
}

var risk_levels_sum = 0
for row in 0..<map_height {
    for col in 0..<map_width {
        let up = get_height(row - 1, col)
        let right = get_height(row, col + 1)
        let down = get_height(row + 1, col)
        let left = get_height(row, col - 1)
        let lowest_neighbour = min(up, right, down, left)
        let center = get_height(row, col)
        if (center < lowest_neighbour) {
            risk_levels_sum += 1 + center
        }
    }
}

print("Risk levels of all lowest points sum up to \(risk_levels_sum)")
