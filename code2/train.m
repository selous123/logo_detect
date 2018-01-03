function [] = train()
clear;
bn_set = {'adidas','becks','cocacola','dhl','ford','google','heineken','starbucks','tsingtao','ups'};
% bn = bn_set{1};
% model = build_model(bn);

model = cell(length(bn_set),1);
for i = 1:length(bn_set)
    bn = bn_set{i};
    model{i} = build_model(bn);
end

save('model.mat','model');