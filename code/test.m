function [] = test()

img1 = im2single(imread('scene.pgm'));
img2 = im2single(imread('box.pgm'));
if numel(size(img1))>2
    img1 = rgb2gray(img1);
end

if numel(size(img2))>2
    img2 = rgb2gray(img2);
end

SIFT_match(img1,img2)