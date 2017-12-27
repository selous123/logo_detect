function [mosaic] = sift_mosaic(im1, im2)
% SIFT_MOSAIC Demonstrates matching two images using SIFT and RANSAC
%
%   SIFT_MOSAIC demonstrates matching two images based on SIFT
%   features and RANSAC and computing their mosaic.
%
%   SIFT_MOSAIC by itself runs the algorithm on two standard test
%   images. Use SIFT_MOSAIC(IM1,IM2) to compute the mosaic of two
%   custom images IM1 and IM2.

% AUTORIGHTS
im1 = im2single(imread(im1));
im2 = im2single(imread(im2));

% make single
im1 = im2single(im1) ;
im2 = im2single(im2) ;

% make grayscale
if size(im1,3) > 1, im1g = rgb2gray(im1) ; else im1g = im1 ; end
if size(im2,3) > 1, im2g = rgb2gray(im2) ; else im2g = im2 ; end

% --------------------------------------------------------------------
%                                                         SIFT matches
% --------------------------------------------------------------------

[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;

[matches, ~] = vl_ubcmatch(d1,d2) ;

numMatches = size(matches,2) ;

X1 = f1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
X2 = f2(1:2,matches(2,:)) ; X2(3,:) = 1 ;

% --------------------------------------------------------------------
%                                         RANSAC with homography model
% --------------------------------------------------------------------

clear H score ok ;
for t = 1:100
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
  ok{t} = (du.*du + dv.*dv) < 6*6 ;
  score(t) = sum(ok{t}) ;
end

[~, best] = max(score) ;
H = H{best} ;
ok = ok{best} ;


% --------------------------------------------------------------------
%                                                         Show matches
% --------------------------------------------------------------------

% dh1 = max(size(im2,1)-size(im1,1),0) ;
% dh2 = max(size(im1,1)-size(im2,1),0) ;
% 
% figure(1) ; clf ;
% subplot(2,1,1) ;
% imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
% o = size(im1,2) ;
% line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
%      [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
% title(sprintf('%d tentative matches', numMatches)) ;
% axis image off ;
% 
% subplot(2,1,2) ;
% imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
% o = size(im1,2) ;
% line([f1(1,matches(1,ok));f2(1,matches(2,ok))+o], ...
%      [f1(2,matches(1,ok));f2(2,matches(2,ok))]) ;
% title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
%               sum(ok),~...
%               100*sum(ok)/numMatches, ...
%               numMatches)) ;
% axis image off ;
% 
% drawnow ;

match = matches(ok);
% Create a new image showing the two images side by side.
img3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap('gray');
imagesc(img3);
hold on;
cols1 = size(im1,2);
line([f1(1,matches(1,ok));f2(1,matches(2,ok))+cols1], ...
      [f1(2,matches(1,ok));f2(2,matches(2,ok))]) ;
hold off;