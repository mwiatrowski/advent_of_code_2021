var measurements = [Int]()
while let line = readLine() {
    if let x = Int(line) {
        measurements.append(x)
    } else {
        print(line + " is not a number!")
    }
}

var increments_num = 0
for (x1, x2) in zip(measurements, measurements.dropFirst(3)) {
    if (x1 < x2) {
        increments_num += 1
    }
}

print("Sums increased " + String(increments_num) + " times")
