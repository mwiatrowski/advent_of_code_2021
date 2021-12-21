let ITERATIONS = 50

func create_image(from input: [String], margin: Int) -> [[UInt8]] {
    var image: [[UInt8]] = []

    let width = 2 * margin + input.first!.count
    for _ in 1...margin {
        image.append([UInt8](repeating: 0, count: width))
    }
    for line in input {
        var row: [UInt8] = []
        for _ in 1...margin {
            row.append(0)
        }
        for symbol in line {
            row.append((symbol == "#") ? 1 : 0)
        }
        for _ in 1...margin {
            row.append(0)
        }
        image.append(row)
    }
    for _ in 1...margin {
        image.append([UInt8](repeating: 0, count: width))
    }

    return image
}

func crop(_ input: [[UInt8]], margin: Int) -> [[UInt8]] {
    var cropped: [[UInt8]] = []
    for row in input.dropFirst(margin).dropLast(margin) {
        var cropped_row: [UInt8] = []
        for value in row.dropFirst(margin).dropLast(margin) {
            cropped_row.append(value)
        }
        cropped.append(cropped_row)
    }
    return cropped
}

func enhance(_ image: [[UInt8]], with rules: [UInt8]) -> [[UInt8]] {
    let width = image.first!.count
    let height = image.count

    func get(_ row: Int, _ col: Int) -> Int {
        if row < 0 || row >= height || col < 0 || col >= width {
            return 0
        }
        return Int(image[row][col])
    }

    var enhanced = image

    for row in 0..<height {
        for col in 0..<width {
            var type = 0

            for dr in (-1)...1 {
                for dc in (-1)...1 {
                    type *= 2
                    type += get(row + dr, col + dc)
                }
            }

            enhanced[row][col] = rules[type]
        }
    }

    return enhanced
}

let rules: [UInt8] = readLine()!.map{ ($0 == "#") ? 1 : 0 }
_ = readLine()!

var image_description: [String] = []
while let line = readLine() {
    image_description.append(line)
}

var image = create_image(from: image_description, margin: 2 * ITERATIONS)

for _ in 1...ITERATIONS {
    image = enhance(image, with: rules)
}

image = crop(image, margin: ITERATIONS)

var light_pixels = 0
for row in image {
    for pixel_value in row {
        light_pixels += Int(pixel_value)
    }
}

print("There are \(light_pixels) light pixels")
