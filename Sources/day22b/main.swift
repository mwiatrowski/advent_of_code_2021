func intersect_range(_ lhs: ClosedRange<Int>, _ rhs: ClosedRange<Int>) -> ClosedRange<Int>? {
    let begin = max(lhs.lowerBound, rhs.lowerBound)
    let end = min(lhs.upperBound, rhs.upperBound)
    if begin > end {
        return nil
    }
    return begin...end
}

class Region {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>
    var z: ClosedRange<Int>
    var subregions: [Region]

    init(_ x: ClosedRange<Int>, _ y: ClosedRange<Int>, _ z: ClosedRange<Int>) {
        self.x = x
        self.y = y
        self.z = z
        self.subregions = []
    }

    func cover(with other: Region) {
        if let intersection = intersect(other) {
            for sub in subregions {
                sub.cover(with: other)
            }
            subregions.append(intersection)
        }
    }

    private func intersect(_ other: Region) -> Region? {
        if let new_x = intersect_range(x, other.x) {
            if let new_y = intersect_range(y, other.y) {
                if let new_z = intersect_range(z, other.z) {
                    return Region(new_x, new_y, new_z)
                }
            }
        }
        return nil
    }

    func count_powered_cubes() -> Int64 {
        var score: Int64 = 0
        score = volume()
        for sub in subregions {
            score -= sub.count_powered_cubes()
        }
        return score
    }

    private func volume() -> Int64 {
        return Int64(x.count) * Int64(y.count) * Int64(z.count)
    }
}

var reactor: [Region] = []

while let line = readLine() {
    let sections = line.split(separator: " ")
    let switch_on = (sections[0] == "on")
    let coords = sections[1]
        .split(separator: ",")
        .map{ $0.split(separator: "=")[1] }
        .map{ $0.split(separator: ".") }
        .map{ Int($0[0])!...Int($0[1])! }

    let new_region = Region(coords[0], coords[1], coords[2])

    for region in reactor {
        region.cover(with: new_region)
    }
    if (switch_on) {
        reactor.append(new_region)
    }
}

var powered_cubes: Int64 = 0
for region in reactor {
    powered_cubes += region.count_powered_cubes()
}

print("\(powered_cubes) cubes are on")
