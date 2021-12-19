struct Point {
    var x: Int
    var y: Int
    var z: Int

    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}
typealias Pointcloud = [Point]
typealias Scanner = [Pointcloud]

extension Point: Hashable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
        hasher.combine(self.z)
    }
}

func sub(_ a: Point, _ b: Point) -> Point {
    return Point(a.x - b.x, a.y - b.y, a.z - b.z)
}

func add(_ a: Point, _ b: Point) -> Point {
    return Point(a.x + b.x, a.y + b.y, a.z + b.z)
}

func norm(_ p: Point) -> Int {
    return max(abs(p.x), max(abs(p.y), abs(p.z)))
}

func get_rotation(_ rot_id: Int) -> (Point) -> Point {
    let face = rot_id / 4
    let yaw = rot_id % 4

    func result(_ p1: Point) -> Point {
        var p2 = p1
        switch yaw {
        case 0:
            p2 = p1
        case 1:
            p2 = Point(p1.x, p1.z, -p1.y)
        case 2:
            p2 = Point(p1.x, -p1.y, -p1.z)
        case 3:
            p2 = Point(p1.x, -p1.z, p1.y)
        default:
            print("Impossible")
        }

        var p3 = p2
        switch face {
        case 0:
            p3 = p2
        case 1:
            p3 = Point(-p2.y, p2.x, p2.z)
        case 2:
            p3 = Point(-p2.x, -p2.y, p2.z)
        case 3:
            p3 = Point(p2.y, -p2.x, p2.z)
        case 4:
            p3 = Point(-p2.z, p2.y, p2.x)
        case 5:
            p3 = Point(p2.z, p2.y, -p2.x)
        default:
            print("Impossible")
        }

        return p3
    }

    return result
}

func make_scanner(_ pointcloud: Pointcloud) -> Scanner {
    var scanner: Scanner = []
    for rot_i in 0...23 {
        let rotation = get_rotation(rot_i)
        var rotated: Pointcloud = []
        for point in pointcloud {
            rotated.append(rotation(point))
        }
        scanner.append(rotated)
    }
    return scanner
}

func parse_input() -> [Scanner] {
    var scanners: [Scanner] = []

    var current_pointcloud: Pointcloud = []
    while let line = readLine() {
        if line.count == 0 {
            continue
        }
        let coords = line.split(separator: ",")
        if coords.count == 3 {
            let coords_int = coords.map{ Int($0)! }
            current_pointcloud.append(Point(coords_int[0], coords_int[1], coords_int[2]))
        } else {
            if (current_pointcloud.count > 0) {
                scanners.append(make_scanner(current_pointcloud))
            }
            current_pointcloud = []
        }
    }
    if current_pointcloud.count > 0 {
        scanners.append(make_scanner(current_pointcloud))
    }

    return scanners
}

func try_align(_ aligned: (Point, Pointcloud), _ other: Scanner) -> (Point, Pointcloud)? {
    for rotated in other {
        if let (origin, points) = try_align_rotated(aligned, rotated) {
            return (origin, points)
        }
    }
    return nil
}

func try_align_rotated(_ aligned: (Point, Pointcloud), _ other: Pointcloud) -> (Point, Pointcloud)? {
    let (_, points) = aligned
    for point_a in points {
        for point_b in other {
            var translated: Pointcloud = []
            let diff = sub(point_a, point_b)
            for p in other {
                translated.append(add(diff, p))
            }

            let other_origin = diff
            if can_align_translated(aligned, (other_origin, translated)) {
                return (other_origin, translated)
            }
        }
    }
    return nil
}

func can_align_translated(_ aligned: (Point, Pointcloud), _ other: (Point, Pointcloud)) -> Bool {
    let (origin_lhs, points_lhs) = aligned
    let (origin_rhs, points_rhs) = other

    let lhs = Set(points_lhs)
    let rhs = Set(points_rhs)

    var common_points = 0
    for point in lhs {
        if rhs.contains(point) {
            common_points += 1
        }
    }
    if common_points < 12 {
        return false
    }

    for point in lhs {
        let dist = norm(sub(origin_rhs, point))
        if rhs.contains(point) != (dist <= 1000) {
            return false
        }
    }

    for point in rhs {
        let dist = norm(sub(origin_lhs, point))
        if lhs.contains(point) != (dist <= 1000) {
            return false
        }
    }

    return true
}

var scanners = parse_input()

var aligned_pointclouds = [(Point, Pointcloud)?](repeating: nil, count: scanners.count)
var new_aligned: [Int] = []

aligned_pointclouds[0] = (Point(0, 0, 0), scanners[0][0])
new_aligned.append(0)

while let i = new_aligned.popLast() {
    let (origin, points) = aligned_pointclouds[i]!
    for (j, other_scanner) in scanners.enumerated() {
        if aligned_pointclouds[j] != nil {
            continue
        }
        if let (new_origin, new_pointcloud) = try_align((origin, points), other_scanner) {
            aligned_pointclouds[j] = (new_origin, new_pointcloud)
            new_aligned.append(j)
        }
    }
}

var all_points: Set<Point> = []
for aligned in aligned_pointclouds {
    let (_, points) = aligned!
    for p in points {
        all_points.insert(p)
    }
}

print("There are \(all_points.count) beacons")
