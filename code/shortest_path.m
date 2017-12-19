function [] = shortest_path(h_bool,central_index)
%h_bool是所有节点之间的连接信息,是否存在链接

num_nodes = size(h_bool,1);
path = cell(1,num_nodes);
for i = 1:num_nodes
    
    h_bool(central_index,i)
     
end
