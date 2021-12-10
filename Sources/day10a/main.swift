func get_score(for line: String) -> Int {
    var bracket_stack: [Character] = []

    func consume(_ bracket: Character) -> Bool {
        if bracket_stack.count == 0 {
            return false;
        }
        let top_bracket = bracket_stack.removeLast()
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
                return 3
            }
        case "]":
            if !consume("[") {
                return 57
            }
        case "}":
            if !consume("{") {
                return 1197
            }
        case ">":
            if !consume("<") {
                return 25137
            }
        default:
            print("Unexpected input!")
        }
    }

    return 0
}

var score = 0
while let line = readLine() {
    score += get_score(for: line)
}

print("\(score) is the total syntax error score")
