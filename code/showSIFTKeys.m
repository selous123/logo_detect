function [] = showSIFTKeys(image_path)
%%
%comment:
%显示图像的sift特征

%%
%code:
img = im2single(imread(image_path));
F = vl_sift(img);
%with shape[4,feature_nums]
%[x,y,scale,orientation]
% Draw image with keypoints
%定义一个窗口
figure('Position', [500,500,size(img,2),size(img,1)]);
colormap('gray');
%将矩阵显示为图像
imagesc(img);
hold on;

F_size = size(F);
feature_num = F_size(2);
for i = 1:feature_num
    TransformLine(F(:,i));
    TransformLineWithArrow(F(:,i), 0.85, 0.1, 1.0, 0.0);
    TransformLineWithArrow(F(:,i), 0.85, -0.1, 1.0, 0.0);
end

hold off;

%%
function [] = TransformLine(feature)
y1 = feature(1);
x1 = feature(2);
scale = 6*feature(3);
theta = feature(4);

s = sin(theta);
c = cos(theta);
%图像的左上角为(0,0),所以计算y的时候要使用减号
y2 = y1-s*scale;
x2 = x1+c*scale;

line([x1 x2],[y1 y2], 'Color', 'c');

function TransformLineWithArrow(keypoint, x1, y1, x2, y2)

% The scaling of the unit length arrow is set to approximately the radius
%   of the region used to compute the keypoint descriptor.
len = 6 * keypoint(3);

% Rotate the keypoints by 'ori' = keypoint(4)
s = sin(keypoint(4));
c = cos(keypoint(4));

% Apply transform
r1 = keypoint(1) - len * (c * y1 + s * x1);
c1 = keypoint(2) + len * (- s * y1 + c * x1);
r2 = keypoint(1) - len * (c * y2 + s * x2);
c2 = keypoint(2) + len * (- s * y2 + c * x2);

line([c1 c2], [r1 r2], 'Color', 'c');



