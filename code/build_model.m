function [] = build_model()
graph = build_graph();
[~,central_index] = max(sum(graph.h_bool,1)'+sum(graph.h_bool,2));
num_nodes = size(graph.h_bool,1);
path = shortest_path(graph.h_bool,central_index);

%所有其他的节点,在中心图像上的映射特征点
%shape = [2,num_features] 
x = [];
D = [];
for i = 1:num_nodes
    if isempty(graph.H{i,central_index})
        graph.H{i,central_index} = ones(3,3);
        for j = 1:size(path{1,i},2)
            graph.H{i,central_index} = graph.H{i,central_index}.*graph.H{path{1,i}(j),path{1,i}(j+1)};
        end
    end
    
    %找出所有在central_img上的匹配点,作为特征点
    x1 = graph.match{i,central_index}.x1;
    x1(3,:) = 1;
    x2 = x1 * graph.H{i,central_index}; 
    x2 = x2(1:2,:);
    %所有的特征点
    x = [x;x2];
    
    %找出所有描述子
    D = [D;graph.match{i,path{1,i}(1)}.D2];
    
    
end

%所有的特征点
x;




