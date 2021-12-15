let ASCII_0 = 48

class Heap<T> {
    var elements: [T]
    var comparator: (T, T) -> Bool

    init(comparator: @escaping (T, T) -> Bool) {
        self.elements = []
        self.comparator = comparator
    }

    func push(_ new_element: T) {
        elements.append(new_element)
        var index = elements.count - 1

        while index > 0 {
            let parent_index = (index - 1) / 2
            if (comparator(elements[parent_index], elements[index])) {
                break
            } else {
                elements.swapAt(parent_index, index)
                index = parent_index
            }
        }
    }

    func pop() -> T? {
        if elements.count == 0 {
            return nil
        }

        elements.swapAt(0, elements.count - 1)
        let result = elements.popLast()!

        var index = 0
        while index < elements.count {
            let child_left_index = 2 * index + 1
            let child_right_index = 2 * index + 2

            if child_right_index < elements.count {
                let value = elements[index]
                let left_value = elements[child_left_index]
                let right_value = elements[child_right_index]

                if (comparator(left_value, right_value)) {
                    if (comparator(value, left_value)) {
                        break
                    } else {
                        elements.swapAt(index, child_left_index)
                        index = child_left_index
                    }
                } else {
                    if (comparator(value, right_value)) {
                        break
                    } else {
                        elements.swapAt(index, child_right_index)
                        index = child_right_index
                    }
                }
            } else if child_left_index < elements.count {
                let value = elements[index]
                let left_value = elements[child_left_index]

                if (comparator(value, left_value)) {
                    break
                } else {
                    elements.swapAt(index, child_left_index)
                    index = child_left_index
                }
            } else {
                break
            }
        }

        return result
    }
}

var risk_levels_limited: [[Int]] = []
while let line = readLine() {
    let row: [Int] =
        [UInt8](line.utf8)
        .map{ Int($0) - ASCII_0 }
    risk_levels_limited.append(row)
}

let original_map_width = risk_levels_limited[0].count
let original_map_height = risk_levels_limited.count

var risk_levels: [[Int]] = []
for vertical_copy in 0...4 {
    for y in 0..<original_map_height {
        var new_row: [Int] = []

        for horizontal_copy in 0...4 {
            for x in 0..<original_map_width {
                let risk_raw = risk_levels_limited[y][x] + horizontal_copy + vertical_copy
                let risk_wrapped = ((risk_raw - 1) % 9) + 1
                new_row.append(risk_wrapped)
            }
        }

        risk_levels.append(new_row)
    }
}

let map_width = risk_levels[0].count
let map_height = risk_levels.count

var distances: [[Int?]] = []
for _ in 1...map_height {
    distances.append([Int?](repeating: nil, count: map_width))
}

var updated_positions = Heap<(Int, Int)>(comparator: {
        let (x1, y1) = $0
        let (x2, y2) = $1
        let dist_1 = distances[y1][x1]!
        let dist_2 = distances[y2][x2]!
        return dist_1 < dist_2
    })

distances[0][0] = 0
updated_positions.push((0, 0))

while let (x, y) = updated_positions.pop() {
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
            updated_positions.push((nx, ny))
        }
    }
}

let lowest_risk = distances[map_height - 1][map_width - 1]!
print("The lowest total risk of any path is equal to \(lowest_risk)")
