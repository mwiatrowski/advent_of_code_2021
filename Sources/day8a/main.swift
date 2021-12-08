var special_digits_count = 0

while let line = readLine() {
    let output_values_string = line.split(separator: "|")[1]
    for output_value in output_values_string.split(separator: " ") {
        let len = output_value.count
        if len != 5 && len != 6 {
            special_digits_count += 1
        }
    }
}

print("There are \(special_digits_count) occurences of 1, 4, 7 or 8 in output values")
