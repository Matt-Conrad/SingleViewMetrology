function [ wrl_file ] = Perspective( in_image,point1,point2,point3,point4,point5,point6,point7,wrl_filename)
%PROJECT1 This function takes a 2D image and outputs an annotated figure
%and wrl file that can be used for 3D perspective
%   Params:
%   in_image = a 2D array image of box 3D perspective
%   point1 = image coordinates (pixel location) of (0,0,+z);
%   point2 = image coordinates (pixel location) of (0,+y,0);
%   point3 = image coordinates (pixel location) of (0,+y,+z)
%   point4 = image coordinates (pixel location) of (+x,+y,+z)
%   point5 = image coordinates (pixel location) of (+x,0,+z)
%   point6 = image coordinates (pixel location) of (+x,0,0)
%   point7 = image coordinates (pixel location) of origin
%   wrl_filename = a string filename describing the name of the 3D
%           perspective file 
%   Outputs:
%   wrl_file = the name of the wrl file, should be same as wrl_filename
% Note: This function relies on the CreateLineVector.m and CreateVRML.m
%       functions

% Read in the image
in_image = im2double(in_image);
in_height = size(in_image,1);
in_width = size(in_image,2);
w = 1;

% Points of interest
point1 = [point1 w]; % (0,0,+z);
point2 = [point2 w]; % (0,+y,0);
point3 = [point3 w]; % (0,+y,+z)
point4 = [point4 w]; % (+x,+y,+z)
point5 = [point5 w]; % (+x,0,+z)
point6 = [point6 w]; % (+x,0,0)
point7 = [point7 w]; % origin

% Create line vectors
[line_ax,line_ay] = CreateLineVector(point3,point4,in_width,in_height);
[line_bx,line_by] = CreateLineVector(point4,point5,in_width,in_height);
[line_cx,line_cy] = CreateLineVector(point1,point3,in_width,in_height);
[line_dx,line_dy] = CreateLineVector(point1,point5,in_width,in_height);
[line_ex,line_ey] = CreateLineVector(point2,point3,in_width,in_height);
[line_fx,line_fy] = CreateLineVector(point1,point7,in_width,in_height);
[line_gx,line_gy] = CreateLineVector(point6,point5,in_width,in_height);
[line_hx,line_hy] = CreateLineVector(point2,point7,in_width,in_height);
[line_ix,line_iy] = CreateLineVector(point6,point7,in_width,in_height);

% Display image and the annotated lines
fig = figure('Name','Annotations');
imshow(in_image,'Border','tight'); hold on;
annotation('line',line_ax,line_ay,'color','g','LineWidth',4);
annotation('line',line_bx,line_by,'color','y','LineWidth',4);
annotation('line',line_cx,line_cy,'color','y','LineWidth',4);
annotation('line',line_dx,line_dy,'color','g','LineWidth',4);
annotation('line',line_ex,line_ey,'color','r','LineWidth',4);
annotation('line',line_fx,line_fy,'color','r','LineWidth',4);
annotation('line',line_gx,line_gy,'color','r','LineWidth',4);
annotation('line',line_hx,line_hy,'color','y','LineWidth',4);
annotation('line',line_ix,line_iy,'color','g','LineWidth',4);
waitfor(fig);

% Compute the homogenous coordinate vector for each line
line_a = cross(point3,point4); line_b = cross(point4,point5); 
line_c = cross(point1,point3); line_d = cross(point1,point5);
line_e = cross(point2,point3); line_f = cross(point1,point7);
line_g = cross(point6,point5); line_h = cross(point2,point7);
line_i = cross(point6,point7);

% Calculate vanishing points
van_u = cross(line_d,line_i);
van_v = cross(line_c,line_h);
van_w = cross(line_f,line_g);

% Scale the vanishing point vectors
van_u = (van_u/van_u(3))';
van_v = (van_v/van_v(3))';
van_w = (van_w/van_w(3))';

% Derive world coordinates for the points using point 7 as the origin
point1_wcs = [0; 0; norm(point1-point7); 1];
point2_wcs = [0; norm(point2-point7); 0; 1];
point6_wcs = [norm(point6-point7); 0; 0; 1];
point3_wcs = point2_wcs+point1_wcs-[0;0;0;1];
point4_wcs = point3_wcs+point6_wcs-[0;0;0;1];
point5_wcs = point6_wcs+point1_wcs-[0;0;0;1];
point7_wcs = [0;0;0;1];

% Calculate scaling factors for each of the first 3 columns in the
% projection matrix
lambda_w_sol = (norm(point1_wcs)*(van_w - point1')) \ (point1' - point7');
lambda_u_sol = (norm(point6_wcs)*(van_u - point6')) \ (point6' - point7');
lambda_v_sol = (norm(point2_wcs)*(van_v - point2')) \ (point2' - point7');

% Construct the projection matrix
P_sol = [lambda_u_sol*van_u lambda_v_sol*van_v lambda_w_sol*van_w point7'];

% Construct the homography matrices for each plane
Huv = [P_sol(:,1) P_sol(:,2) P_sol(:,4)];
Huw = [P_sol(:,1) P_sol(:,3) P_sol(:,4)];
Hvw = [P_sol(:,2) P_sol(:,3) P_sol(:,4)];

% Build the transform object for each plane and warp the original image 
tform = projective2d(inv(Huw)');
out_image_uw = imwarp(in_image,tform);
tform = projective2d(inv(Huv)');
out_image_uv = imwarp(in_image,tform);
tform = projective2d(inv(Hvw)');
out_image_vw = imwarp(in_image,tform);

% Allow the user to crop so that just the face is showing
fig = figure('Name','CROP TO THE FLUSHED FACE');
[I1, ~] = imcrop(out_image_uw); 
if exist("I1","var")
    close(fig);
end
fig = figure('Name','CROP TO THE FLUSHED FACE');
[I2, ~] = imcrop(out_image_uv); 
if exist("I2","var")
    close(fig);
end
fig = figure('Name','CROP TO THE FLUSHED FACE');
[I3, ~] = imcrop(out_image_vw); 
if exist("I3","var")
    close(fig)
end

% Save the faces 
imwrite(I1,'uw.bmp');
imwrite(I2,'uv.bmp');
imwrite(I3,'vw.bmp');

% Write parameters to a wrl file
fid = fopen(wrl_filename,'w+');
fprintf(fid,'#VRML V2.0 utf8\n\nCollision {\n collide FALSE\n children [\n');

uv_points = [point1_wcs point5_wcs point4_wcs point3_wcs];
uw_points = [point1_wcs point5_wcs point6_wcs point7_wcs];
vw_points = [point3_wcs point1_wcs point7_wcs point2_wcs];

CreateWRL(fid,'uv.bmp',uv_points);
CreateWRL(fid,'uw.bmp',uw_points);
CreateWRL(fid,'vw.bmp',vw_points);

fprintf(fid,'   ]\n}');
fclose(fid);

wrl_file = wrl_filename;

end
