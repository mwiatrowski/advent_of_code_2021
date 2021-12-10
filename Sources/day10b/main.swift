func get_autocomplete_score(for line: String) -> Int64? {
    var bracket_stack: [Character] = []

    func consume(_ bracket: Character) -> Bool {
        let top_bracket = bracket_stack.popLast()
        return bracket == top_bracket
    }

    for bracket in line {
        switch bracket {
        case "(":
            bracket_stack.append(bracket)
        case "[":
            bracket_stack.append(bracket)
        case "{":
            bracket_stack.append(bracket)
        case "<":
            bracket_stack.append(bracket)
        case ")":
            if !consume("(") {
                return nil
            }
        case "]":
            if !consume("[") {
                return nil
            }
        case "}":
            if !consume("{") {
                return nil
            }
        case ">":
            if !consume("<") {
                return nil
            }
        default:
            print("Unexpected input!")
        }
    }

    var score: Int64 = 0
    while let bracket = bracket_stack.popLast() {
        score *= 5

        switch bracket {
        case "(":
            score += 1
        case "[":
            score += 2
        case "{":
            score += 3
        case "<":
            score += 4
        default:
            print("bracket_stack is corrupted!")
        }
    }

    return score
}

var all_scores: [Int64] = []
while let line = readLine() {
    if let score = get_autocomplete_score(for: line) {
        all_scores.append(score)
    }
}
all_scores.sort()

let middle_score = all_scores[all_scores.count / 2]

print("The middle score is \(middle_score)")
