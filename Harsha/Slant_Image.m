clc;
clear all;
close all;
A=imread('cameraman.tif');
figure,imshow(uint8(A))
title('Original Image');
A=double(A);
[s1 s2]=size(A);
% bs=input('Enter the block sizes for division of the image: '); % Block Size
bs=256;

% Slant
temp=double(zeros(size(A)));
for y=1:bs:s1-bs+1
    for x=1:bs:s2-bs+1
        croppedImage = A((y:y+bs-1),(x:x+bs-1));
        t=getSlantTransform(croppedImage,bs);
        temp((y:y+bs-1),(x:x+bs-1))=t;
    end
end
figure,imshow(uint8(temp))

% Inverse Slant
temp1=double(zeros(size(A)));
for y=1:bs:s1-bs+1
    for x=1:bs:s2-bs+1
        croppedImage = temp((y:y+bs-1),(x:x+bs-1));
        t=getInvSlantTransform(croppedImage,bs);
        temp1((y:y+bs-1),(x:x+bs-1))=t;
    end
end
figure,imshow(uint8(temp1))