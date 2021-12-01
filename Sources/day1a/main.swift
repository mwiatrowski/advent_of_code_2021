var measurements = [Int]()
while let line = readLine() {
    if let x = Int(line) {
        measurements.append(x)
    } else {
        print(line + " is not a number!")
    }
}

var increments_num = 0
var last_measurement = measurements[0]
for measurement in measurements {
    if measurement > last_measurement {
        increments_num += 1
    }
    last_measurement = measurement
}

print("Measurement increased " + String(increments_num) + " times")
