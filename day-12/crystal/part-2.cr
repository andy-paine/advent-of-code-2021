ins = STDIN.gets_to_end.strip.split("\n").map(&.split("-")).map { |i| Tuple(String, String).from(i) }
graph = (ins + ins.map(&.reverse)).group_by(&.first).map { |k, v| {k, v.map(&.last)} }.to_h

def visit?(visited, n)
  return false if n == "start"
  return true if !visited.includes? n
  visited.tally.values.all?(&.== 1)
end

def all_paths(graph : Hash(String, Array(String)), s, visited, path, paths)
  path.push(s)
  visited += [s] if s.downcase == s
  if s == "end"
    paths.push path.dup
  else
    graph[s].each { |n| all_paths(graph, n, visited, path, paths) if visit?(visited, n) }
  end
  visited.delete(path.pop)
end

paths = [] of Array(String)
all_paths(graph, "start", [] of String, [] of String, paths)
puts paths.size
