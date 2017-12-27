function [inliers_num] = ComputeInliers(H_matrix,source_img,des_img)
%%
%comment:
%给定转化矩阵h_matrix,返回source_img和des_img
%source_img*H_matrix与des_img匹配的个数
%Args  :
%   source_img:sift feature of source_img,with shape[feature_num,3]
%   des_img   :sift feature of des image,with shape [feature_num,3]
%Return:
%   inliers_num:match number.
%
%%
%code:
threshold = 0.01;

des_result = source_img*H_matrix;
des_result=des_result./repmat(des_result(:,3),1,3);
des_result_size = size(des_result);
des_img_size = size(des_img);
visited_des_img = zero(des_img_size(1));

num = 0;
for i=1:des_result_size(1)
    for j =1:des_img_size(1)
        if visited_des_img(j)
            break;
        end
        %如果两个向量的范数小于threshold,则认为两个向量匹配
        if norm(des_result-des_img)<=threshold
            visited_des_img(j)=1;
            num = num+1;
        end
    end
end

inliers_num = num;

