function [] = test(model,img1)
%%
%测试代码
%path = '/mnt/hgfs/ubuntu14/dataset/FlickrLogos-v2/classes/jpg/ad/144503924.jpg'
%img1 = rgb2gray(im2single(imread(path)))
%test(model,img1);
%%
isshow=1;
edge_thresh = 100;
%图像1和图像2的sift特征匹配

%showSIFTKeys(img_path1);
%showSIFTKeys(img_path2);

%F with shape [4,feature_num]
%[X;Y;S;TH], where X,Y is the (fractional) center of the frame, S is the scale and TH is the orientation (in radians)
%D with shape [128,feature_num]
[F1,D1] = vl_sift(img1,'edgethresh', edge_thresh);
X2_raw=model.primary_model.x;
D2=model.primary_model.D;

[match,~] = vl_ubcmatch(D1,D2,1.2);
numMatches = size(match,2);

X1 = F1(1:2,match(1,:)) ; 
X1(3,:) = 1 ;
X2 = X2_raw(:,match(2,:));
X2(3,:) = 1 ;


%DLT,计算homograph转化矩阵
for t = 1:3000
  % estimate homograpyh
  subset = vl_colsubset(1:numMatches, 4) ;
  A = [] ;
  for i = subset
    A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
  end
  [~,~,V] = svd(A) ;
  H{t} = reshape(V(:,9),3,3) ;

  % score homography
  X2_ = H{t} * X1 ;
  du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
  dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
  ok{t} = (du.*du + dv.*dv) <36 ;
  score(t) = sum(ok{t}) ;
end

%取100个循环中,最好的H matrix

[~, best] = max(score) ;
H_best = H{best} ;
ok = ok{best} ;
match = match(:,ok);
% 
num_matches = size(match,2);

img2 = model.data{model.primary_model.nodes(model.primary_model.central_index)};
%%show
% Create a new image showing the two images side by side.
if isshow==1
    img3 = appendimages(img1,img2);
    % Show a figure with lines joining the accepted matches.
    figure('Position', [100 100 size(img3,2) size(img3,1)]);
    colormap('gray');
    imagesc(img3);
    hold on;
    cols1 = size(img1,2);
    %画出所有的匹配点
    line([F1(1,match(1,:));X2_raw(1,match(2,:))+cols1], ...
          [F1(2,match(1,:));X2_raw(2,match(2,:))]) ;
    hold off;
end
