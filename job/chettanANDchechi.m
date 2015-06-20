%a = imaqhwinfo;
%[camera_name, camera_id, format] = getCameraInfo(a);

clc;clear;close all;ii=700;iii=0;
% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
vid = VideoReader('DSCF2134.AVI');
% Set a loop that stop after 100 frames of aquisition
while(ii<vid.NumberOfFrame)
    ii=ii+1;
    % Get the snapshot of the current frame
    data = read(vid,ii);
    data=imrotate(data,-90);
   data=data(100:400,:,:);
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(data(:,:,1), rgb2gray(data));
     background = imopen(diff_im,strel('square',15));
     diff_im=diff_im+background;
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.18);
    
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,30);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
%     fff=createfigure3(data,fff);
    imshow(data)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    if(length(stats)==3)
iii=iii+1;
        bb = stats(1).BoundingBox;
        bc = stats(1).Centroid;
        rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
%         plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
         set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        
        bb = stats(2).BoundingBox;
         bc = stats(2).Centroid;
        rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
%         plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
         set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        
        bb = stats(3).BoundingBox;
        bc = stats(3).Centroid;
        rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
%         plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
%        fff=createfigure2(bb1, bb2, bb3, bc1, bc2, bc3,fff);
       X=[stats(1).Centroid(1) stats(2).Centroid(1) stats(3).Centroid(1)]; 
       Y=[stats(1).Centroid(2) stats(2).Centroid(2) stats(3).Centroid(2)];
% anglee(i)=round(find_angle(X,Y));
anglee(iii)=round(find_anglee(X,Y));
    end
    hold off
    end
% Both the loops end here.

anglee(anglee>90)=180-anglee(anglee>90);
plot(anglee);

