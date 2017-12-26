function [model] = identify_separate_connected_components(h_bool,central_index)
%
num_nodes = size(h_bool,1);
model_nodes = 1:num_nnodes;
primary_model_nodes = central_index;

%定义一个队列
central_indexes = central_index;
while(central_indexes)
    %第一个元素出队
    tmp_central_index = central_indexes(1);
    central_indexes(1) = [];
    for i = 1:num_nodes
        if h_bool{i,tmp_central_index}==1
            central_indexes = [central_indexes,i];
            %将i加入到主模型的nodes集合中
            primary_model_nodes = [primary_model_nodes,i];
        end
    end
end

model.primary_model.nodes = primary_model_nodes;
[~, ia, ~] = intersect(model_nodes,primary_model_nodes);
rest_nodes = model_nodes(ia);
for i = rest_nodes
    [~,~,num_matches] = SIFT_match(data{1,i},data{1,central_index});
    if num_matches>20
        index = i;
        break; 
    end
end

if index~=[]
    model.second_model_exist = 1;
    %定义一个队列
    second_model_nodes = index;
    central_indexes = index;
    while(central_indexes)
        %第一个元素出队
        tmp_central_index = central_indexes(1);
        central_indexes(1) = [];
        for i = 1:num_nodes
            if h_bool{i,tmp_central_index}==1
                central_indexes = [central_indexes,i];
                %将i加入到主模型的nodes集合中
                second_model_nodes = [second_model_nodes,i];
            end
        end
    end
    model.second_model.nodes = second_model_nodes;
else
    model.second_model_exist = 0;
end;
