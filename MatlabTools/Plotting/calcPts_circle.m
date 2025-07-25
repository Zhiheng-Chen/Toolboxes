function [pts_x,pts_y] = calcPts_circle(r_center,R,N_pts)
%Zhiheng Chen
%2/5/2024

pts_circle = linspace(0,2*pi,N_pts);
pts_x = r_center(1)+R.*cos(pts_circle);
pts_y = r_center(2)+R.*sin(pts_circle);
end