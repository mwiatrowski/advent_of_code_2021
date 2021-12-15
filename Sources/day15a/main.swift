let ASCII_0 = 48

var risk_levels: [[Int]] = []
while let line = readLine() {
    let row: [Int] =
        [UInt8](line.utf8)
        .map{ Int($0) - ASCII_0 }
    risk_levels.append(row)
}

let map_width = risk_levels[0].count
let map_height = risk_levels.count

var distances: [[Int?]] = []
for _ in 1...map_height {
    distances.append([Int?](repeating: nil, count: map_width))
}

var updated_positions: [(Int, Int)] = []

distances[0][0] = 0
updated_positions.append((0, 0))

while updated_positions.count > 0 {
    let (x, y) = updated_positions.popLast()!
    let distance = distances[y][x]!

    for (dx, dy) in [(-1, 0), (0, 1), (1, 0), (0, -1)] {
        let nx = x + dx
        let ny = y + dy
        if nx < 0 || nx >= map_width || ny < 0 || ny >= map_height {
            continue
        }

        let n_risk = risk_levels[ny][nx]
        let n_current_dist = distances[ny][nx] ?? (distance + n_risk + 1)
        if distance + n_risk < n_current_dist {
            distances[ny][nx] = distance + n_risk
            updated_positions.append((nx, ny))
        }
    }

    updated_positions.sort(by: { position1, position2 in
            let dist_1 = distances[position1.1][position1.0]!
            let dist_2 = distances[position2.1][position2.0]!
            return dist_1 > dist_2
        })
}

let lowest_risk = distances[map_height - 1][map_width - 1]!
print("The lowest total risk of any path is equal to \(lowest_risk)")
