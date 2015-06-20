function FrameRateDisplay(obj, event,vid)
persistent IM;
persistent handlesRaw;
persistent handlesPlot;

trigger(vid);
IM=getdata(vid,1);
if isempty(handlesRaw)
   % if first execution, we create the figure objects
     handlesRaw=imagesc(IM);
   title('CurrentImage');
   
 
   % Plot first value
   Values=0;figure
   subplot(111)
   handlesPlot=plot(Values);
   
   title('Angle');
   xlabel('Frame number');
   ylabel('Angle in Degrees');
   
 
else
    
     diff_im = imsubtract(IM(:,:,1), rgb2gray(IM));
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.18);
    
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
%     stats = regionprops(bw, 'BoundingBox', 'Centroid');
     stats = regionprops(bw,'Centroid');
    % Display the image

set(handlesRaw,'CData',IM);
    
    %This is a loop to bound the red objects in a rectangular box.
    if(length(stats)==3)

%         bb = stats(1).BoundingBox;
        bc = stats(1).Centroid;
%         rectangle('Position',bb,'LineWidth',2,...
%     'EdgeColor',[0 0 1]);
% 
%         text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));

        
%         bb = stats(2).BoundingBox;
         bc = stats(2).Centroid;
%        rectangle('Position',bb,'LineWidth',2,...
%     'EdgeColor',[0 0 1]);
% 
%         text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));

        
%         bb = stats(3).BoundingBox;
        bc = stats(3).Centroid;
%         rectangle('Position',bb,'LineWidth',2,...
%     'EdgeColor',[0 0 1]);
% 
%         text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));


       X=[stats(1).Centroid(1) stats(2).Centroid(1) stats(3).Centroid(1)]; 
       Y=[stats(1).Centroid(2) stats(2).Centroid(2) stats(3).Centroid(2)];

anglee=round(find_anglee(X,Y));
    
   % We only update what is needed
   
   Value=anglee;
   OldValues=get(handlesPlot,'YData');
   set(handlesPlot,'YData',[OldValues Value]);
    end
end