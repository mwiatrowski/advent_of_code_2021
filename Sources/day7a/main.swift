let crab_positions = readLine()!.split(separator: ",").map{ Int($0)! }
let best_position = crab_positions.sorted()[crab_positions.count / 2]

let total_cost =
    crab_positions.reduce(into: 0) {
        cost, position in cost += abs(position - best_position)
    }

print("Crabs must spend at least \(total_cost) fuel")
