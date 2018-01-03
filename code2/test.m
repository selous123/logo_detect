function [num_matches] = test(model,img1)
%%
%测试代码
%path = '/mnt/hgfs/ubuntu14/dataset/FlickrLogos-v2/classes/jpg/ad/144503924.jpg'
%img1 = rgb2gray(im2single(imread(path)))
%test(model,img1);
%%
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
num_match = zeros(2,1);

for j = 1:2
    [match,~] = vl_ubcmatch(D1,D2,1.2);
    numMatches = size(match,2);
    X1 = F1(1:2,match(1,:)) ; 
    X1(3,:) = 1 ;
    X2 = X2_raw(:,match(2,:));
    X2(3,:) = 1 ;
    epoch_nums = 500;
    
    %初始化
    H = cell(epoch_nums,1);
    ok = cell(epoch_nums,1);
    score = zeros(epoch_nums,1);
    %DLT,计算homograph转化矩阵
    for t = 1:epoch_nums
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
    ok = ok{best} ;
    match = match(:,ok);
    % 
    num_match(j) = size(match,2);
    
    if model.second_model_exist==1
        X2_raw=model.second_model.x;
        D2=model.second_model.D;
    else
        break;
    end
end

num_matches = max(num_match);
