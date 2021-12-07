let crab_positions = readLine()!.split(separator: ",").map{ Int($0)! }
let mean: Int = crab_positions.reduce(0, +) / crab_positions.count

func cost(_ target_position: Int) -> Int {
    var total_cost = 0
    for crab_position in crab_positions {
        let distance = abs(crab_position - target_position)
        total_cost += ((distance + 1) * distance) / 2
    }
    return total_cost
}

let lowest_cost = min(cost(mean), cost(mean + 1))

print("Crabs must spend at least \(lowest_cost) fuel")
