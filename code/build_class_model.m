function [x,D] = build_class_model(h_bool,H,match,central_index)
%%
%args:
%   h_bool:节点之间是否存在连接
%   H     :节点之间连接的矩阵
%%
num_nodes = size(h_bool,2);
path = shortest_path(h_bool,central_index);
%部分其他的节点,在中心图像上的映射特征点
%shape = [2,num_features] 
tic
x = [];
D = [];
for i = 1:num_nodes
    if i==central_index
        continue;
    end
    %if isempty(graph.H{i,central_index})
    if h_bool(i,central_index) == 0
        %创建一个临时的H,
        H_temp = ones(3,3);
        for j = 1:size(path{1,i},2)-1
            %与到中心图像的最短路径上面的所有的H点乘,计算composition homography
             H_temp= H_temp.*H{path{1,i}(j),path{1,i}(j+1)};
             H{i,central_index} = H_temp;
        end
    end
    
    %如果图像i与中心图像存在homography
    if ~isempty(H{i,central_index})
        %找出所有在central_img上的匹配点,作为特征点
%         graph.H{3,1}
%         path{1,3}
%         path{1,i}(1)
%         graph.match{3,1}
        x1 = match{i,path{1,i}(1)}.X1;
        x1(3,:) = 1;
        
        %graph.H{i,central_index}
        x2 = H{i,central_index}*x1;
        x2 = x2./repmat(x2(3,:),3,1);
        x2 = x2(1:2,:);
        %所有的特征点
        %size(x2)
        x = [x,x2];
        %找出所有描述子
        D = [D,match{i,path{1,i}(1)}.D1];  
    end
end
toc
