function [graph] = build_graph()
%%
%构建图信息
%graph(struct)的属性:
%   x     :节点的图像信息
%   h_bool:节点之间是否存在连接
%   H     :节点之间连接矩阵
%   match :图像之间连接的点信息
%       x1:图像1匹配的特征点
%       x2:图像2匹配的特征点
%       D1:图像1匹配特征点的描述子
%       D2:图像2匹配特征点的描述子
%example:
%   graph.H{i,j} 是 graph.x{1,i} 与 graph.y{1,j}的homograph矩阵
%   graph.match{i,j}.x1是graph.x{1,i}的特征点,
%   graph.match{i,j}.x2是graph.x{1,j}的特征点.
%   graph.match{i,j}.D1是graph.x{1,i}的描述子
%   graph.match{i,j}.D2是graph.x{1,j}的描述子

%%
%读取图片,储存在graph.x中
%每一张图表示一个节点
root_path = '/mnt/hgfs/ubuntu14/dataset/FlickrLogos-v2/classes/jpg/';
classfy = 'adida';
images = dir(fullfile(root_path,classfy));

size(images);
images = images(3:size(images,1));
num_nodes = size(images,1);

%图信息
graph.x = cell(1,num_nodes);
for i =1:num_nodes
    path = fullfile(root_path,classfy,images(i).name);
    graph.x{1,i} =  im2single(imread(path));
    if numel(size(graph.x{1,i}))>2
        graph.x{1,i} = rgb2gray(graph.x{1,i});
    end
end

%%
%计算节点之间的链接信息
graph.h_bool = zeros(num_nodes,num_nodes);
graph.H = cell(num_nodes,num_nodes);
graph.match = cell(num_nodes,num_nodes);
for i =1:num_nodes
    for j =1:num_nodes
        %如果,直接跳过
        if i==j
            continue;
        end
        %num_matches是特征点个数
        [graph.H{i,j},graph.match{i,j},num_matches] = SIFT_match(graph.x{1,i},graph.x{1,j});
        if num_matches>20
            graph.h_bool(i,j) = 1;
        else
            graph.H{i,j} = [];
        end
    end
end


