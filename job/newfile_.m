%a = imaqhwinfo;
%[camera_name, camera_id, format] = getCameraInfo(a);

clc;clear;close all;
% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
vid = videoinput('winvideo', 1, 'YUY2_640x480');
NumberFrameDisplayPerSecond=30;
% Set the properties of the video object
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
set(vid, 'FramesPerTrigger', 1);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 1;
triggerconfig(vid, 'Manual');
% fff=figure;
%start the video aquisition here
% set up timer object
TimerData=timer('TimerFcn', {@FrameRateDisplay,vid},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
hFigure=figure(1);
start(vid);
start(TimerData);
 
% We go on until the figure is closed
uiwait(hFigure);
 
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
clear functions;