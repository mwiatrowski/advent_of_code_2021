import Foundation

struct Fissure {
    var x1, y1, x2, y2: Int
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

var fissures: [Fissure] = []
while let line = readLine() {
    let endpoints: [[Int]] =
        line.components(separatedBy: "->")
        .map{
            $0.split(separator: ",")
            .map{ Int(String($0).trim())! }
        }

    let fissure = Fissure(
        x1: min(endpoints[0][0], endpoints[1][0]),
        y1: min(endpoints[0][1], endpoints[1][1]),
        x2: max(endpoints[0][0], endpoints[1][0]),
        y2: max(endpoints[0][1], endpoints[1][1])
    )

    if fissure.x1 == fissure.x2 || fissure.y1 == fissure.y2 {
        fissures.append(fissure)
    }
}

var covered_points: [(Int, Int)] = []
for fissure in fissures {
    if fissure.x1 == fissure.x2 {
        let x = fissure.x1
        for y in fissure.y1...fissure.y2 {
            covered_points.append((x, y))
        }
    } else if fissure.y1 == fissure.y2 {
        let y = fissure.y1
        for x in fissure.x1...fissure.x2 {
            covered_points.append((x, y))
        }
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
