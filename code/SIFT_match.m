function [] = SIFT_match(img_path1,img_path2)
%图像1和图像2的sift特征匹配
img1 = im2single(imread(img_path1));
img2 = im2single(imread(img_path2));

if numel(size(img1))>2
    img1 = rgb2gray(img1);
end

if numel(size(img2))>2
    img2 = rgb2gray(img2);
end

%showSIFTKeys(img_path1);
%showSIFTKeys(img_path2);

%F with shape [4,feature_num]
%D with shape [128,feature_num]
[F1,D1] = vl_sift(img1);
[F2,D2] = vl_sift(img2);

% D1 = double(D1);
% D2 = double(D2);

% For each descriptor in the first image, select its match to second image.
% D2t = D2';
% Precompute matrix transpos
% for i = 1 : m
%    %dotprods = D2t * D1(:,i);        % Computes vector of dot products
%    %[vals,indx] = sort(dotprods);  % Take inverse cosine and sort results
%    D1_repmat = repmat(D1(:,i),1,size(D2,2));
%    euclidean_metric = sum(D2.*D1_repmat,1);
%    [vals,indx] = sort(euclidean_metric);
%    
%    
%    % Check if nearest neighbor has angle less than distRatio times 2nd.
%    if (vals(1) < distRatio*vals(2))
%        match(i) = indx(1);
%    else
%        match(i) = 0;
%    end
% end

[match,scores] = vl_ubcmatch(D1,D2);
numMatches = size(match,2);


X1 = F1(1:2,match(1,:)) ; 
X1(3,:) = 1 ;
X2 = F2(1:2,match(2,:)) ; 
X2(3,:) = 1 ;


%DLT,计算homograph转化矩阵
for t = 1:100
  % estimate homograpyh
  subset = vl_colsubset(1:numMatches, 4) ;
  A = [] ;
  for i = subset
    A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
  end
  [U,S,V] = svd(A) ;
  H{t} = reshape(V(:,9),3,3) ;

  % score homography
  X2_ = H{t} * X1 ;
  du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
  dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
  ok{t} = (du.*du + dv.*dv) < 6*6 ;
  score(t) = sum(ok{t}) ;
end

%取100个循环中,最好的H matrix

[score, best] = max(score) ;
H_best = H{best} ;
ok = ok{best} ;
match = match(:,ok);


% Create a new image showing the two images side by side.
img3 = appendimages(img1,img2);
% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap('gray');
imagesc(img3);
hold on;
cols1 = size(img1,2);
%画出所有的匹配点
line([F1(1,match(1,:));F2(1,match(2,:))+cols1], ...
      [F1(2,match(1,:));F2(2,match(2,:))]) ;
hold off;