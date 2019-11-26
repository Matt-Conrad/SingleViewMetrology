function [x_vector,y_vector] = CreateLineVector(start_point,end_point,im_width,im_height)
%CREATELINEVECTOR Solves for x and y vectors given a start and end x,y
%point
%   start_point = the starting point in [x,y]
%   end_point = the ending point in [x,y]
%   im_width = the number of columns 
%   im_height = the number of rows

x_vector = [ start_point(1,1)/im_width , end_point(1,1)/im_width ];
y_vector = [ (1 - start_point(1,2)/im_height) , (1 - end_point(1,2)/im_height) ];

end
