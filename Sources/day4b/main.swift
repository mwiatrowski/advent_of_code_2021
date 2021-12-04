let numbers: [Int] = readLine()!.split(separator: ",").map{ Int($0)! }
let number_of_turns = numbers.count

var order: [Int: Int] = [:]
for (i, value) in numbers.enumerated() {
    order[value] = i
}

func calculate_winning_turn(board: [[Int]]) -> Int {
    var winning_turn: Int = number_of_turns

    for row in 0...4 {
        var row_completion_turn: Int = 0
        for col in 0...4 {
            let value = board[row][col]
            let turn_when_marked = order[value] ?? number_of_turns
            row_completion_turn = max(row_completion_turn, turn_when_marked)
        }
        winning_turn = min(winning_turn, row_completion_turn)
    }

    for col in 0...4 {
        var col_completion_turn: Int = 0
        for row in 0...4 {
            let value = board[row][col]
            let turn_when_marked = order[value] ?? number_of_turns
            col_completion_turn = max(col_completion_turn, turn_when_marked)
        }
        winning_turn = min(winning_turn, col_completion_turn)
    }

    return winning_turn
}

var worst_winning_turn = 0
var worst_score = 0

while readLine() != nil {
    var board: [[Int]] = []

    for _ in 0...4 {
        let values = readLine()!.split(separator: " ").map{ Int($0)! }
        board.append(values)
    }

    let winning_turn = calculate_winning_turn(board: board)
    if winning_turn >= worst_winning_turn {
        var score = 0
        for row in 0...4 {
            for col in 0...4 {
                let value = board[row][col]
                let turn_when_marked = order[value] ?? number_of_turns
                if turn_when_marked > winning_turn {
                    score += value
                }
            }
        }
        score *= numbers[winning_turn]

        worst_winning_turn = winning_turn
        worst_score = score
    }
}

print("Worst board won on turn \(worst_winning_turn) (counting from 0)")
print("Score of that board: \(worst_score)")
