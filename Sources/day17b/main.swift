import Foundation

let ASCII_MINUS: UInt8 = 45
let ASCII_0: UInt8 = 48
let ASCII_9: UInt8 = 57
let ASCII_SPACE: UInt8 = 32

func parse_input(_ input: String) -> (Int, Int, Int, Int) {
    let bytes = [UInt8](input.utf8)
    var bytes_clear: [UInt8] = []
    for byte in bytes {
        if byte == ASCII_MINUS || (byte >= ASCII_0 && byte <= ASCII_9) {
            bytes_clear.append(byte)
        } else {
            bytes_clear.append(ASCII_SPACE)
        }
    }
    let numbers =
        String(bytes: bytes_clear, encoding: .ascii)!
        .split(separator: " ")
        .map{ Int($0)! }

    return (numbers[0], numbers[1], numbers[2], numbers[3])
}

let (x1, x2, y1, y2) = parse_input(readLine()!)

if x1 <= 0 || x2 <= 0 || y1 >= 0 || y2 >= 0 {
    print("Target area coordinates are outside of accepted range!")
}
if x1 > x2 || y1 > y2 {
    print("Target area coordinates are not ordered properly!")
}

func triangle(_ n: Int, _ k: Int) -> Int {
    return ((2 * n - k + 1) * k) / 2
}
func triangle(_ n: Int) -> Int {
    return triangle(n, n)
}

var good_initial_velocities = 0
top_level_loop: for initial_y in ((y1)...(-y1 - 1)).reversed() {
    for initial_x in 0...x2 {
        for steps in 1... {
            let x = (steps >= initial_x) ? triangle(initial_x) : triangle(initial_x, steps)
            let y = triangle(initial_y, steps)

            if x1 <= x && x <= x2 && y1 <= y && y <= y2 {
                good_initial_velocities += 1
                break
            }

            if y < y1 {
                break
            }
        }
    }
}

print("There are \(good_initial_velocities) good initial velocity values")
