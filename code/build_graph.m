function [graph] = build_graph()
root_path = '/mnt/hgfs/ubuntu14/dataset/FlickrLogos-v2/classes/jpg/';
classfy = 'ad';
images = dir(fullfile(root_path,classfy));

size(images);
images = images(3:size(images,1));
num_nodes = size(images,1);

%图信息
graph.x = cell(1,num_nodes);
graph.y = cell(1,num_nodes);
for i =1:num_nodes
    path = fullfile(root_path,classfy,images(i).name);
    graph.x{1,i} =  im2single(imread(path));
    if numel(size(graph.x{1,i}))>2
        graph.x{1,i} = rgb2gray(graph.x{1,i});
    end
    graph.y{1,i} = graph.x{1,i};
end
graph.h_bool = zeros(num_nodes,num_nodes);
graph.H = cell(num_nodes,num_nodes);
graph.match = cell(num_nodes,num_nodes);
for i =1:num_nodes
    for j =i+1:num_nodes
        %graph.H{i,j} 是 graph.x{1,i} 与 graph.y{1,j}的homograph矩阵
        %graph.match{i,j}.x1是graph.x{1,i}的特征点,
        %graph.match{i,j}.x2是graph.y{1,j}的特征点.
        %num_matches是特征点个数
        [graph.H{i,j},graph.match{i,j},num_matches] = SIFT_match(graph.x{1,i},graph.y{1,j});
        if num_matches>20
            graph.h_bool(i,j) = 1;
            graph.h_bool(j,i) = 1;
        else
            graph.H{i,j} = [];
        end
        graph.H{j,i} = graph.H{i,j};
    end
end


