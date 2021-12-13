var points: [(Int, Int)] = []
while let line = readLine() {
    if line.count == 0 {
        break
    }
    let coordinates = line.split(separator: ",")
    let x = Int(coordinates[0])!
    let y = Int(coordinates[1])!
    points.append((x, y))
}

var transforms: [(Character, Int)] = []
while let line = readLine() {
    let line_description = String(line.split(separator: " ")[2])
    let axis = line_description.first!
    let value_index = line_description.index(line_description.startIndex, offsetBy: 2)
    let value = Int(line_description.suffix(from: value_index))!
    transforms.append((axis, value))
}

points = points.map{
    var x = $0.0
    var y = $0.1
    for (axis, value) in transforms {
        if axis == "x" {
            x = value - abs(value - x)
        } else {
            y = value - abs(value - y)
        }
        break
    }
    return (x, y)
}

points.sort{
    let (x1, y1) = $0
    let (x2, y2) = $1
    return (x1 < x2) || (x1 == x2 && y1 < y2)
}

points = points.reduce(into: []) { unique_points, point in
    if unique_points.count == 0 || unique_points.last! != point {
        unique_points.append(point)
    }
}

print("There are \(points.count) visible dots after completing the first fold")
