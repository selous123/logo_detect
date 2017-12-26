function [model] = build_model()

%%%build graph
tic
graph = build_graph();
[~,central_index] = max(sum(graph.h_bool,1)'+sum(graph.h_bool,2));
toc 

model = identify_separate_connected_components(graph.h_bool,central_index);

%%
%model的属性:
%   data         :数据,指的是图像的数据
%   primary_model:主模型
%       nodes        :主模型所包含的节点
%       central_index:中心图像的标签
%       x            :特征点
%       D            :描述符子
%   second_model_exist:翻转模型是否存在
%   second_model :光学反转模型
%       nodes        :反转模型所包含的节点
%       central_index:中心图像的标签
%       x            :特征点
%       D            :描述符子
%   
%%
model.data = graph.x{1,:};

primary_h_bool = graph.h_bool(model.primary_model.nodes,model.primary_model.nodes);
primary_H = graph.H{model.primary_model.nodes,model.primary_model.nodes};
[model.primary_model.x,model.primary_model.D] = build_class_model(primary_h_bool,primary_H,model.primary_model.central_index);


if model.second_model_exist==1
    second_h_bool = graph.h_bool(model.second_model.nodes,model.second_model.nodes);
    second_H = graph.H{model.second_model.nodes,model.second_model.nodes};
    [model.second_model.x,model.second_model.D] = build_class_model(second_h_bool,second_H,model.second_model.central_index);
end


model























img = graph.x{1,central_index};
%所有的特征点
figure('Position', [500,500,size(img,2),size(img,1)]);
colormap('gray');
%将矩阵显示为图像
imagesc(img);
hold on
for i=1:size(x,2)
    plot(x(1,i),x(2,i),'.');
end
hold off
% size(graph.x{1,central_index})
% size(D)
% size(x)
% max(x(1,:))
% max(x(2,:))



