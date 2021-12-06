let DAYS: Int = 256

// fish_score[N] represents how many new fish will be born if we:
//     - start with a single fish that's going to give birth on the next day
//     - run the experiment for N days
var fish_score = [Int64](repeating: 0, count: DAYS + 1)
func get_score(_ days_left: Int) -> Int64 {
    return (days_left < 0) ? 0 : fish_score[days_left]
}

fish_score[0] = 0
for duration in 1...DAYS {
    fish_score[duration] = 1 + get_score(duration - 7) + get_score(duration - 9)
}

var total_fish_count: Int64 = 0
for fish_timer in readLine()!.split(separator: ",").map({ Int($0)! }) {
    total_fish_count += 1 + fish_score[DAYS - fish_timer]
}

print("There would be \(total_fish_count) fish after \(DAYS) days")
