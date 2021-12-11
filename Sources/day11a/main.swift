let ASCII_ZERO = 48

class Queue<T> {
    var stack_in: [T] = []
    var stack_out: [T] = []

    func push(_ value: T) {
        stack_in.append(value)
    }

    func pop() -> T? {
        if stack_out.count == 0 {
            while (!stack_in.isEmpty) {
                stack_out.append(stack_in.popLast()!)
            }
        }
        return stack_out.popLast()
    }
}

var energy_levels: [[Int]] = []
while let line = readLine() {
    let row: [Int] =
        line.map({ (digit: Character) -> Int in Int(digit.asciiValue!) - ASCII_ZERO })
    energy_levels.append(row)
}

let map_width = energy_levels[0].count
let map_height = energy_levels.count

func simulate_one_step() -> Int {
    let octopuses_ready_to_flash = Queue<(Int, Int)>()

    var flashed_this_turn: [[Bool]] = []
    for _ in 1...map_height {
        flashed_this_turn.append([Bool](repeating: false, count: map_width))
    }

    for row in 0..<map_height {
        for col in 0..<map_width {
            energy_levels[row][col] += 1
            if energy_levels[row][col] > 9 {
                energy_levels[row][col] = 0
                flashed_this_turn[row][col] = true
                octopuses_ready_to_flash.push((row, col))
            }
        }
    }

    while let (row, col) = octopuses_ready_to_flash.pop() {
        let neighbours = [
            (-1, -1), (-1, 0), (-1, 1),
            ( 0, -1),          ( 0, 1),
            ( 1, -1), ( 1, 0), ( 1, 1)
        ]

        for (dr, dc) in neighbours {
            if row + dr < 0 || row + dr >= map_height || col + dc < 0 || col + dc >= map_width {
                continue
            }
            if flashed_this_turn[row + dr][col + dc] {
                continue
            }
            energy_levels[row + dr][col + dc] += 1
            if energy_levels[row + dr][col + dc] > 9 {
                energy_levels[row + dr][col + dc] = 0
                flashed_this_turn[row + dr][col + dc] = true
                octopuses_ready_to_flash.push((row + dr, col + dc))
            }
        }
    }

    var number_of_flashes = 0
    for row in flashed_this_turn {
        for did_flash in row {
            if did_flash {
                number_of_flashes += 1
            }
        }
    }
    return number_of_flashes
}

var total_flashes = 0
for _ in 1...100 {
    total_flashes += simulate_one_step()
}

print("There have been a total of \(total_flashes) flashes")
