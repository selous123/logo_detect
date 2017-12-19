function [] = build_model()
graph = build_graph();
[~,central_index] = max(sum(graph.h_bool,1)'+sum(graph.h_bool,2));

graph.h_bool