
clear;
bn_set = {'adidas','becks','cocacola','dhl','ford','google','heineken','starbucks','tsingtao','ups'};
% bn = bn_set{1};
% model = build_model(bn);

model = cell(length(bn_set),1);
for i = 1:length(bn_set)
    bn = bn_set{i};
    model{i} = build_model(bn);
end
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
    for k = 3:length(jpgs)
        count = count +1;
        img = im2single(rgb2gray(imread(fullfile(jpgs(k).folder, jpgs(k).name))));
        
        test(model{i,1},img);
        if pred == i
            correct = correct + 1;
        end
    end
    result(i) = correct/count;
end

