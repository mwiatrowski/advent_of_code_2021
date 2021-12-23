let CUBOID_RANGE = -50...50

func bisect_range(_ range: ClosedRange<Int>) -> (ClosedRange<Int>, ClosedRange<Int>)? {
    if range.count <= 1 {
        return nil
    } else {
        let half_len = range.count / 2
        let end_1 = range.lowerBound + half_len - 1
        let start_2 = range.lowerBound + half_len
        let half_1 = range.lowerBound...end_1
        let half_2 = start_2...range.upperBound

        return (half_1, half_2)
    }
}

func intersect(_ lhs: ClosedRange<Int>, _ rhs: ClosedRange<Int>) -> ClosedRange<Int>? {
    let begin = max(lhs.lowerBound, rhs.lowerBound)
    let end = min(lhs.upperBound, rhs.upperBound)
    if begin > end {
        return nil
    }
    return begin...end
}

struct Region {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>
    var z: ClosedRange<Int>

    init(_ x: ClosedRange<Int>, _ y: ClosedRange<Int>, _ z: ClosedRange<Int>) {
        self.x = x
        self.y = y
        self.z = z
    }

    func volume() -> Int64 {
        return Int64(x.count) * Int64(y.count) * Int64(z.count)
    }

    func bisect() -> [Region] {
        if volume() <= 1 {
            return []
        }

        if x.count >= y.count && x.count >= z.count {
            let (x1, x2) = bisect_range(x)!
            return [Region(x1, y, z), Region(x2, y, z)]
        } else if y.count >= z.count {
            let (y1, y2) = bisect_range(y)!
            return [Region(x, y1, z), Region(x, y2, z)]
        } else {
            let (z1, z2) = bisect_range(z)!
            return [Region(x, y, z1), Region(x, y, z2)]
        }
    }

    func intersection(_ other: Region) -> Region? {
        if let new_x = intersect(x, other.x) {
            if let new_y = intersect(y, other.y) {
                if let new_z = intersect(z, other.z) {
                    return Region(new_x, new_y, new_z)
                }
            }
        }
        return nil
    }
}

extension Region: Hashable {
    static func == (lhs: Region, rhs: Region) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

class Tree {
    var tree: [Region: Bool]
    let root: Region

    init() {
        root = Region(CUBOID_RANGE, CUBOID_RANGE, CUBOID_RANGE)
        tree = [root: false]
    }

    func count_powered_cubes() -> Int64 {
        return count_internal(in: root)
    }

    private func count_internal(in node: Region) -> Int64 {
        if let is_on = tree[node] {
            return is_on ? node.volume() : 0
        }

        var count: Int64 = 0
        for subnode in node.bisect() {
            count += count_internal(in: subnode)
        }
        return count
    }

    func set(_ region: Region, _ is_on: Bool) {
        if let intersection = region.intersection(root) {
            internal_set(intersection, on: root, is_on)
        }
    }

    private func internal_set(_ region: Region, on node: Region, _ value: Bool) {
        if region == node {
            tree[node] = value
            return
        }

        if let old_value = tree[node] {
            tree[node] = nil
            for subnode in node.bisect() {
                tree[subnode] = old_value
            }
        }

        for subnode in node.bisect() {
            if let subregion = region.intersection(subnode) {
                internal_set(subregion, on: subnode, value)
            }
        }
    }
}

let reactor = Tree()

while let line = readLine() {
    let sections = line.split(separator: " ")
    let switch_on = (sections[0] == "on")
    let coords = sections[1]
        .split(separator: ",")
        .map{ $0.split(separator: "=")[1] }
        .map{ $0.split(separator: ".") }
        .map{ Int($0[0])!...Int($0[1])! }
    let region = Region(coords[0], coords[1], coords[2])

    if let _ = region.intersection(reactor.root) {
        reactor.set(region, switch_on)
    }
}

print("\(reactor.count_powered_cubes()) cubes are on")
