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
    }
    return (x, y)
}

var min_x = points[0].0
var min_y = points[0].1
var max_x = points[0].0
var max_y = points[0].1
for (x, y) in points {
    min_x = min(min_x, x)
    min_y = min(min_y, y)
    max_x = max(max_x, x)
    max_y = max(max_y, y)
}

var visualization: [[Character]] = []
for _ in min_y...max_y {
    visualization.append([Character](repeating: " ", count: max_x - min_x + 1))
}

for (x, y) in points {
    visualization[y - min_y][x - min_x] = "#"
}

print("This is the activation code:")
for row in visualization {
    for character in row {
        print(character, terminator: "")
    }
    print()
}
