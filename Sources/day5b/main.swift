import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

var covered_points: [(Int, Int)] = []
while let line = readLine() {
    let coordinates: [(Int)] =
        line.components(separatedBy: "->")
        .flatMap{ $0.split(separator: ",") }
        .map{ Int(String($0).trim())! }

    let (x1, y1, x2, y2) = (coordinates[0], coordinates[1], coordinates[2], coordinates[3])

    let dx = (x2 - x1).signum()
    let dy = (y2 - y1).signum()

    let distance = (x1 != x2) ? abs(x2 - x1) : abs(y2 - y1)

    for i in 0...distance {
        let x = x1 + i * dx
        let y = y1 + i * dy
        covered_points.append((x, y))
    }
}

covered_points.sort{
    let (x1, y1) = $0
    let (x2, y2) = $1
    return (x1 < x2) || (x1 == x2 && y1 < y2)
}

var many_times_covered: [(Int, Int)] =
    zip(covered_points, covered_points.dropFirst(1))
    .filter{ $0 == $1 }
    .map{ $0.0 }
    .reduce(into: []) { unique_points, point in
        if unique_points.count == 0 || unique_points.last! != point {
            unique_points.append(point)
        }
    }

print("There are \(many_times_covered.count) points where at least 2 fissures overlap")
