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

var visited = [Bool](repeating: false, count: graph.count)
func count_paths(from origin: Int) -> Int {
    if origin == end_id {
        return 1
    }

    if is_small[origin] {
        visited[origin] = true
    }

    var paths_count = 0
    for neighbour in graph[origin] {
        if !visited[neighbour] {
            paths_count += count_paths(from: neighbour)
        }
    }

    visited[origin] = false
    return paths_count
}

var number_of_paths = count_paths(from: start_id)
print("There are \(number_of_paths) possible paths")
