var cave_ids: [String: Int] = [:]
func get_cave_id(for name: String) -> Int {
    if let id = cave_ids[name] {
        return id
    } else {
        let new_id = cave_ids.count
        cave_ids[name] = new_id
        return new_id
    }
}

var graph: [[Int]] = []
while let line = readLine() {
    let caverns = line.split(separator: "-")
    let id1 = get_cave_id(for: String(caverns[0]))
    let id2 = get_cave_id(for: String(caverns[1]))
    while graph.count <= max(id1, id2) {
        graph.append([])
    }
    graph[id1].append(id2)
    graph[id2].append(id1)
}

let start_id = cave_ids["start"]!
let end_id = cave_ids["end"]!

var is_small = [Bool](repeating: false, count: graph.count)
for entry in cave_ids {
    let name = entry.key
    let id = entry.value
    is_small[id] = name.first!.isLowercase
}

var visits = [Int](repeating: 0, count: graph.count)
func count_paths(from origin: Int, revisiting chosen_id: Int?) -> Int {
    if origin == end_id {
        return 1
    }

    if is_small[origin] {
        if visits[origin] >= 1 && chosen_id == nil && origin != start_id {
            return count_paths(from: origin, revisiting: origin)
        }

        let limit = (origin == chosen_id) ? 2 : 1
        if visits[origin] >= limit {
            return 0
        }
    }

    var paths_count = 0

    visits[origin] += 1
    for neighbour in graph[origin] {
        paths_count += count_paths(from: neighbour, revisiting: chosen_id)
    }
    visits[origin] -= 1

    return paths_count
}

var number_of_paths = count_paths(from: start_id, revisiting: nil)
print("There are \(number_of_paths) possible paths")
