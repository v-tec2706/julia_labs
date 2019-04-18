
module Graphs

using StatsBase

export GraphVertex, NodeType, Person, Address,
       generate_random_graph, get_random_person, get_random_address, generate_random_nodes,
       convert_to_graph,
       bfs, check_euler, partition,
       graph_to_str, node_to_str,
       test_graph

#= Single graph vertex type.
Holds node value and information about adjacent vertices =#
mutable struct GraphVertex
  value
  neighbors ::Vector
end

# Types of valid graph node's values.
abstract type NodeType end

# ! deklaracja typów pola typów złożonych
mutable struct Person <: NodeType
  name :: String
end

mutable struct Address <: NodeType
  streetNumber :: Int8  # adresy tylko w zakresie 1 - 100
end

# !  zamiana zmiennych globalnych na stałe
# Number of graph nodes.
const N = Int64(800)
# Number of graph edges.
const K = Int64(10000)

#= Generates random directed graph of size N with K edges
and returns its adjacency matrix.=#
function generate_random_graph()
    A :: BitArray{2}= falses(N, N)
    @simd for i in sample(1:N*N, K, replace=false)
      @inbounds A[i] = true
    end
    A
end

# Generates random person object (with random name).
#function get_random_person(person::Array{String})
 # person[1] = randstring()
 # nothing
#end

# Generates random person object (with random name).
#function get_random_address(adress::Array{Int8})
#  adress[1]=rand(Int8(1):Int8(100))
#  nothing
#end
# ! nie uzywane

# Generates N random nodes (of random NodeType).
function generate_random_nodes()
  nodes = Vector{NodeType}()
  for i= 1:N
    push!(nodes, rand() > 0.5 ? Person(randstring()) : Address(rand(Int8(1):Int8(100))))
  end
  nodes
end

#= Converts given adjacency matrix (NxN)
  into list of graph vertices (of type GraphVertex and length N). =#
function convert_to_graph(A::BitArray{2}, nodes::Vector{NodeType})

  N = length(nodes)
  graph::Array{GraphVertex,1}
  push!(graph, map(n -> GraphVertex(n, GraphVertex[]), nodes)...)

  @simd for j = 1:N
      @simd for  i = 1:N
      @inbounds if A[i,j] == 1
        @inbounds push!(graph[i].neighbors, graph[j])
            end
        end
    end
end

# ! znajomość typu na jakim dokonane będą operację umożliwi kompilatorowi optymalizację

#= Groups graph nodes into connected parts. E.g. if entire graph is connected,
  result list will contain only one part with all nodes. =#
function partition()
  parts = Set{GraphVertex}[]
  remaining = Set(graph)
  visited = bfs(remaining=remaining)
  push!(parts, Set(visited))

  while !isempty(remaining)
    new_visited = bfs(visited=visited, remaining=remaining)
    push!(parts, new_visited)
  end
  parts
end

#= Performs BFS traversal on the graph and returns list of visited nodes.
  Optionally, BFS can initialized with set of skipped and remaining nodes.
  Start nodes is taken from the set of remaining elements. =#
function bfs(;visited=Set(), remaining=Set(graph))
  first = next(remaining, start(remaining))[1]
  q = [first]
  push!(visited, first)
  delete!(remaining, first)
  local_visited = Set([first])

  while !isempty(q)
    v = pop!(q)


    @simd for n in v.neighbors
      if !(n in visited)
        @inbounds push!(q, n)
        @inbounds push!(visited, n)
        @inbounds push!(local_visited, n)
        delete!(remaining, n)
      end
    end
  end
  local_visited
end

#= Checks if there's Euler cycle in the graph by investigating
   connectivity condition and evaluating if every vertex has even degree =#
function check_euler()
  if length(partition()) == 1
    return all(map(v -> iseven(length(v.neighbors)), graph))
  end
    "Graph is not connected"
end

#= Returns text representation of the graph consisiting of each node's value
   text and number of its neighbors. =#

# ! modyfikacja graph_to_str

function node_to_str(node_str :: String,x :: Person)
     node_str ="**** \nPerson: $(x.name)"
end

function node_to_str(node_str :: String,x :: Address)
     node_str = "Street Nr: $(x.streetNumber)"
end

function graph_to_str()
  graph_str = ""
  node_str = ""
  for v in graph
    node_to_str(node_str,v.value)
    graph_str *= node_str
    graph_str *= "\nNeighbors: $(length(v.neighbors))\n"
  end
  graph_str
end

#= Tests graph functions by creating 100 graphs, checking Euler cycle
  and creating text representation. =#
function test_graph()
  for i=1:100
    global graph = GraphVertex[]

    A = generate_random_graph()
    nodes = generate_random_nodes()
    convert_to_graph(A, nodes)

    str = graph_to_str()
    #println(str)
    println(check_euler())
  end
end

#code_llvm(test_graph,())

end
