% Project Part 1
% Matt Conrad
% 10/16/2017

%% Full algorithm on box1.jpg
in_image = im2double(rgb2gray(imread('box1.jpg')));
imshow(in_image); 

[BW, thresh] = edge(in_image,'Roberts', 0.018 ,'nothinning');
imshow(BW)

[H,T,R] = hough(BW, 'RhoResolution', 2.5);

% Display the Hough transform, T = theta, R = rho, H = transform value
fig = imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'); ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot)

P  = houghpeaks(H, 10, 'threshold', 0.15*max(H(:)), 'NHoodSize', [101 101]);
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(BW,T,R,P,'FillGap',125,'MinLength',20);
figure, imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% Points of interest
point1 = lines(4).point2; % (0,0,+z);
point2 = lines(1).point1; % (0,+y,0);
point3 = lines(4).point1; % (0,+y,+z)
point4 = lines(8).point2; % (+x,+y,+z)
point5 = lines(5).point2; % (+x,0,+z)
point6 = lines(6).point1; % (+x,0,0)
point7 = lines(6).point2; % origin

% Continue with the part 1 algorithm
wrl_filename = 'test.wrl';
Perspective(in_image,point1,point2,point3,point4,point5,point6,point7,wrl_filename);

