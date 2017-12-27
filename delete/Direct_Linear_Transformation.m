function [trans_matrix] = Direct_Linear_Transformation(source_matrix,des_matrix)
%%
%comment:
%X' = PX
%已知X'和X,求解P
%args:
%   source_matrix:X,with shape[4,3]
%   des_matrix   :X',with shape[4,3]
%return:
%   trans_matrix :P,with shape [3,3]
A = zeros(8,9);
A_node = zeros(3,4,3);
for i = 1:3
    A_node(i,:,:) = repmat(des_matrix(:,i),1,3).*source_matrix;
end
A(1:4,4:6) = -A_node(3,:,:);
A(5:8,1:3) = A_node(3,:,:);
A(1:4,7:9) = A_node(2,:,:);
A(5:8,7:9) = -A_node(1,:,:);

%A with shape [8,9]
result = null(A,'r');
sum_result = sum(result,2);
%a = A*sum_result;
result = sum_result;
trans_matrix = reshape(result,[3,3]);

