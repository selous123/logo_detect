function [] = read_data()
root_path = '/mnt/hgfs/ubuntu14/dataset/FlickrLogos-v2/classes/jpg/adidas';

images = dir(root_path);

size(images);
images = images(3:size(images,1));
img1_name = fullfile(root_path,images(2).name);
img2_name = fullfile(root_path,images(3).name);
img1 = im2single(imread(img1_name));
img2 = im2single(imread(img2_name));

if numel(size(img1))>2
    img1 = rgb2gray(img1);
end

if numel(size(img2))>2
    img2 = rgb2gray(img2);
end
%showSIFTKeys(img1);
%showSIFTKeys(img2);


SIFT_match(img1,img2)
% root_path = '/mnt/hgfs/ubuntu14/dataset/flickr_logos_27_dataset/flickr_logos_27_dataset_images';
% file_path = '/mnt/hgfs/ubuntu14/dataset/flickr_logos_27_dataset/flickr_logos_27_dataset_training_set_annotation.txt';
% 
% fid = fopen(file_path);
% dcells = textscan(fid,'%s %s %d %d %d %d %d');
% fclose(fid);
% 
% file_num = size(dcells{1});
% crops = cell2mat(dcells(4:7));
% 
% for index = 1:file_num
%     file_name = dcells{1}{index};
% %     img = imread(fullfile(root_path,file_name));
% %     figure;
% %     imshow(img)
%     img{index} =  fullfile(root_path,file_name);
% end
% 
% %showSIFTKeys(img{1})
% %showSIFTKeys(img{3})
% SIFT_match(img{4},img{13},crops(4,:),crops(13,:));
