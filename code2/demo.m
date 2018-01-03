model = load('model.mat').model;
% 
% 
% 
% bn = bn_set{1};
% jpgs = dir(fullfile('D:\course\课程设计\dataset\flickr_logo_32',bn,'test'));
% for k = 3:length(jpgs)
%     img = im2single(rgb2gray(imread(fullfile(jpgs(k).folder, jpgs(k).name))));
%     
%     test(model,img);
% end
result = zeros(length(bn_set),1);
for i = 1:10
    bn = bn_set{i};
    jpgs = dir(fullfile('D:\course\课程设计\dataset\flickr_logo_32',bn,'test'));
    count = 0;
    correct = 0;
    %10*60(test_data_num)
    num_matches = zeros(10,60);
    for k = 3:length(jpgs)
        count = count +1;
        img = im2single(rgb2gray(imread(fullfile(jpgs(k).folder, jpgs(k).name))));
        %对于这10个模型做匹配
        for j=1:10
            num_matches(j,k) = test(model{j,1},img);
        end
    end
    
    [~,pred] = max(num_matches);
    result(i) = sum(pred == i)/count;
end

