% Project Part 1
% Matt Conrad
% 10/16/2017

%% Test using input.bmp
% The point of this test is to run the sony.bmp image through the
% Perspective function. This was the first part of the project.
clear all; clc;
in_image = im2double(imread('input.bmp'));
point_picker = imtool(in_image); % USE IMTOOL TO GET POINTS OF INTEREST
waitfor(point_picker);
% Points of interest
point1 = [395,402]; % (0,0,+z);
point2 = [176,367]; % (0,+y,0);
point3 = [165,230]; % (0,+y,+z)
point4 = [380,141]; % (+x,+y,+z)
point5 = [619,294]; % (+x,0,+z)
point6 = [609,429]; % (+x,0,0)
point7 = [394,541]; % origin
wrl_filename = 'output.wrl';
Perspective(in_image,point1,point2,point3,point4,point5,point6,point7,wrl_filename);
