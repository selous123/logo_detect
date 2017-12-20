function [path] = shortest_path(h_bool,central_index)
%h_bool是所有节点之间的连接信息,是否存在链接

num_nodes = size(h_bool,1);
path = cell(1,num_nodes);
central_indexes = central_index;
path{1,central_index} = central_index;
while(central_indexes)
    central_index = central_indexes(1);
    central_indexes(1) = [];
    for i = 1:num_nodes
        if path{1,i}
            %路径已经找到
            continue;
        else
            if h_bool(central_index,i)==1
                path{1,i} = [path{1,central_index},i];
                central_indexes = [central_indexes,i];
            end
        end
    end
end

for i = 1:num_nodes
    path{1,i}
end