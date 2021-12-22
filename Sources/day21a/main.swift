let POINTS_LIMIT = 1000

let player1_start = Int(readLine()!.split(separator: " ").last!)!
let player2_start = Int(readLine()!.split(separator: " ").last!)!

func add_wrap(_ lhs: Int, _ rhs: Int, _ range: ClosedRange<Int>) -> Int {
    let sum = lhs + rhs
    return (sum - range.lowerBound) % (range.count) + range.lowerBound
}

var dice_next = 1
var dice_rolls = 0
func roll_the_dice() -> Int {
    let result = dice_next
    dice_next = add_wrap(dice_next, 1, 1...100)
    dice_rolls += 1
    return result
}

var points = [0, 0]
var position = [player1_start, player2_start]

top_level_loop: while true {
    for i in [0, 1] {
        let move = roll_the_dice() + roll_the_dice() + roll_the_dice()
        position[i] = add_wrap(position[i], move, 1...10)
        points[i] += position[i]
        if points[i] >= POINTS_LIMIT {
            break top_level_loop
        }
    }
}

let losing_player_score = points.min()!
let answer = losing_player_score * dice_rolls

print("Losing player score multiplied by the number of times the die was rolled gives \(answer)")
