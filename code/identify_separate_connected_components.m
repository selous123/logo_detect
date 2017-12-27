function [model] = identify_separate_connected_components(h_bool,data,central_index)
%%计算主模型的信息
num_nodes = size(h_bool,1);
model_nodes = 1:num_nodes;
primary_model_nodes = central_index;

%定义一个队列
central_indexes = central_index;
while(central_indexes)
    %第一个元素出队
    tmp_central_index = central_indexes(1);
    central_indexes(1) = [];
    for i = 1:num_nodes
        if ismember(i,primary_model_nodes)
           continue; 
        end
        if h_bool(i,tmp_central_index)==1
            central_indexes = [central_indexes,i];
            %将i加入到主模型的nodes集合中
            primary_model_nodes = [primary_model_nodes,i];
        end
    end
end

%%
%寻找光学反转模型,
%寻找策略:将余下的节点反转后,判断与主模型的central image是否匹配
model.primary_model.nodes = primary_model_nodes;
[~, ia, ~] = intersect(model_nodes,primary_model_nodes);
rest_nodes = model_nodes;
rest_nodes(ia) = [];
index=0;
%寻找一个与主模型互为光学反转模型的图像
%下标记为index
for i = rest_nodes
    [~,~,num_matches] = SIFT_match(1-data{1,i},data{1,central_index});
    if num_matches>20
        index = i;
        break; 
    end
end

if index~=0
    model.second_model_exist = 1;
    %定义一个队列
    second_model_nodes = index;
    central_indexes = index;
    while(central_indexes)
        %第一个元素出队
        tmp_central_index = central_indexes(1);
        central_indexes(1) = [];
        for i = rest_nodes
            if ismember(i,second_model_nodes)
                continue;
            end
            if h_bool(i,tmp_central_index)==1
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

%如果只有一个节点
if size(model.second_model.nodes,2)==1
    model.second_model_exist = 0;
end
