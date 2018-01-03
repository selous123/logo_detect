function [model] = build_model(bn)
%%
%model的属性:
%   data         :数据,指的是图像的数据
%   primary_model:主模型
%       nodes        :主模型所包含的节点
%       central_index:中心图像的标签,在nodes中的位置.
%               nodes(central_index)才是中心图像的标签
%       x            :特征点
%       D            :描述符子
%   second_model_exist:翻转模型是否存在
%   second_model :光学反转模型
%       nodes        :反转模型所包含的节点
%       central_index:中心图像的标签,在nodes中的位置.
%               nodes(central_index)才是中心图像的标签
%       x            :特征点
%       D            :描述符子

%%
%run('/home/lrh/software/matlab_package/vlfeat-0.9.20/toolbox/vl_setup')
%%%build graph
tic
graph = build_graph(bn);
%？？
%？？
%？？重要
%手动设置不匹配
toc 
[~,central_index] = max(sum(graph.h_bool,1)'+sum(graph.h_bool,2));
model = identify_separate_connected_components(graph.h_bool,graph.x,central_index);


%%
model.data = graph.x;

%从graph中取出与primary model相关的匹配信息
primary_h_bool = graph.h_bool(model.primary_model.nodes,model.primary_model.nodes);
primary_H = graph.H(model.primary_model.nodes,model.primary_model.nodes);
primary_match = graph.match(model.primary_model.nodes,model.primary_model.nodes);
[~,model.primary_model.central_index] = max(sum(primary_h_bool,1)'+sum(primary_h_bool,2));

%使用这些信息,构建class model
%也就是计算model中的所有节点在中心图像上的映射x和D
[model.primary_model.x,model.primary_model.D] = build_class_model(primary_h_bool,primary_H,primary_match,model.primary_model.central_index);


if model.second_model_exist==1
    %从graph中取出与second model相关的匹配信息
    second_h_bool = graph.h_bool(model.second_model.nodes,model.second_model.nodes);
    second_H = graph.H(model.second_model.nodes,model.second_model.nodes);
    second_match = graph.match(model.second_model.nodes,model.second_model.nodes);
    [~,model.second_model.central_index] = max(sum(second_h_bool,1)'+sum(second_h_bool,2));
    
    %构建second model
    [model.second_model.x,model.second_model.D] = build_class_model(second_h_bool,second_H,second_match,model.second_model.central_index);
end


img = model.data{1,model.primary_model.nodes(model.primary_model.central_index)};
x = model.primary_model.x;

% img = model.data{1,model.second_model.nodes(model.second_model.central_index)};
% x = model.second_model.x;
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



