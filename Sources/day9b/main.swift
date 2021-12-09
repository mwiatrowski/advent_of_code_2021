let ASCII_ZERO = 48

var map: [[Int]] = []
while let line = readLine() {
    let row: [Int] =
        line.map({ (digit: Character) -> Int in Int(digit.asciiValue!) - ASCII_ZERO })
    map.append(row)
}

let map_width = map[0].count
let map_height = map.count

var destinations: [[(Int, Int)?]] = []
for _ in 1...map_height {
    destinations.append([(Int, Int)?](repeating: nil, count: map_width))
}

func get_height(_ row: Int, _ col: Int) -> Int {
    if col < 0 || col >= map_width || row < 0 || row >= map_height {
        return 10
    }
    return map[row][col]
}

func find_destination(_ row: Int, _ col: Int) -> (Int, Int)? {
    if col < 0 || col >= map_width || row < 0 || row >= map_height {
        return nil
    }
    if map[row][col] == 9 {
        return nil
    }
    if destinations[row][col] != nil {
        return destinations[row][col]
    }

    let neighbours = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    var possible_destinations: [(Int, Int)] = []
    for (row_d, col_d) in neighbours {
        if get_height(row, col) > get_height(row + row_d, col + col_d) {
            if let neighbour_destination = find_destination(row + row_d, col + col_d) {
                possible_destinations.append(neighbour_destination)
            }
        }
    }

    if possible_destinations.count == 0 {
        destinations[row][col] = (row, col)
    } else {
        for destination in possible_destinations {
            if destination != possible_destinations.first! {
                print("Input map is wrong!")
            }
        }
        destinations[row][col] = possible_destinations.first!
    }

    return destinations[row][col]
}

var destination_scores: [[Int]] = []
for _ in 0..<map_height {
    destination_scores.append([Int](repeating: 0, count: map_width))
}

for row in 0..<map_height {
    for col in 0..<map_width {
        if let (dest_row, dest_col) = find_destination(row, col) {
            destination_scores[dest_row][dest_col] += 1
        }
    }
}

var all_scores: [Int] = []
for row in 0..<map_height {
    for col in 0..<map_width {
        all_scores.append(destination_scores[row][col])
    }
}
all_scores.sort(by: >)

let sizes_product = all_scores[0] * all_scores[1] * all_scores[2]
print("Sizes of the three largest basins multiplied together give \(sizes_product)")
