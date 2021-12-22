let POINTS_LIMIT = 21

let player1_start = Int(readLine()!.split(separator: " ").last!)!
let player2_start = Int(readLine()!.split(separator: " ").last!)!

func add_wrap(_ lhs: Int, _ rhs: Int, _ range: ClosedRange<Int>) -> Int {
    let sum = lhs + rhs
    return (sum - range.lowerBound) % (range.count) + range.lowerBound
}

struct GameState {
    var scores: [Int]
    var positions: [Int]
    var first_goes_next: Bool

    init(_ initial_positions: [Int]) {
        scores = [0, 0]
        positions = initial_positions
        first_goes_next = true
    }
}

extension GameState: Hashable {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.scores == rhs.scores &&
               lhs.positions == rhs.positions &&
               lhs.first_goes_next == rhs.first_goes_next
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(scores)
        hasher.combine(positions)
        hasher.combine(first_goes_next ? 1 : 0)
    }
}

var cached_results: [GameState: (Int64, Int64)] = [:]

func get_wins(for state: GameState) -> (Int64, Int64) {
    if let result = cached_results[state] {
        return result
    }

    if state.scores[0] >= POINTS_LIMIT {
        return (1, 0)
    } else if state.scores[1] >= POINTS_LIMIT {
        return (0, 1)
    }

    var wins: (Int64, Int64) = (0, 0)
    let next_player = state.first_goes_next ? 0 : 1

    for (rolls_sum, count) in [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)] {
        var new_state = state
        let new_position = add_wrap(state.positions[next_player], rolls_sum, 1...10)
        new_state.positions[next_player] = new_position
        new_state.scores[next_player] = state.scores[next_player] + new_position
        new_state.first_goes_next = !state.first_goes_next

        let wins_in_new_state = get_wins(for: new_state)
        wins.0 += Int64(count) * wins_in_new_state.0
        wins.1 += Int64(count) * wins_in_new_state.1
    }

    cached_results[state] = wins
    return wins
}

let initial_state = GameState([player1_start, player2_start])
let (player1_wins, player2_wins) = get_wins(for: initial_state)

print("Winning player wins in \(max(player1_wins, player2_wins)) universes")
