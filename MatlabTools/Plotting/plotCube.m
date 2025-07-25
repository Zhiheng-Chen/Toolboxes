function plotCube(L,W,H,HTM)
%Zhiheng Chen
%2/12/2024

%position of eight vertices before transformation
r_front_UR = [L/2 -W/2 H/2]';
r_front_UL = [-L/2 -W/2 H/2]';
r_front_LL = [-L/2 -W/2 -H/2]';
r_front_LR = [L/2 -W/2 -H/2]';
r_back_UR = [L/2 W/2 H/2]';
r_back_UL = [-L/2 W/2 H/2]';
r_back_LL = [-L/2 W/2 -H/2]';
r_back_LR = [L/2 W/2 -H/2]';

r_vertices = zeros(3,8);
r_vertices(:,1) = r_front_UR;
r_vertices(:,2) = r_front_UL;
r_vertices(:,3) = r_front_LL;
r_vertices(:,4) = r_front_LR;
r_vertices(:,5) = r_back_UR;
r_vertices(:,6) = r_back_UL;
r_vertices(:,7) = r_back_LL;
r_vertices(:,8) = r_back_LR;

%homogeneous transformation
for ii = 1:8
    r_vertice = [r_vertices(:,ii);1];
    r_vertice = HTM*r_vertice;
    r_vertice = r_vertice(1:3);
    r_vertices(:,ii) = r_vertice;
end

%plot front
pts_front_x = r_vertices(1,1:4);
pts_front_y = r_vertices(2,1:4);
pts_front_z = r_vertices(3,1:4);
fill3(pts_front_x,pts_front_y,pts_front_z,"white");
hold on;

%plot back
pts_back_x = r_vertices(1,5:8);
pts_back_y = r_vertices(2,5:8);
pts_back_z = r_vertices(3,5:8);
fill3(pts_back_x,pts_back_y,pts_back_z,"white");

%plot left
pts_left_x = r_vertices(1,[2,3,7,6]);
pts_left_y = r_vertices(2,[2,3,7,6]);
pts_left_z = r_vertices(3,[2,3,7,6]);
fill3(pts_left_x,pts_left_y,pts_left_z,"white");

%plot right
pts_right_x = r_vertices(1,[1,4,8,5]);
pts_right_y = r_vertices(2,[1,4,8,5]);
pts_right_z = r_vertices(3,[1,4,8,5]);
fill3(pts_right_x,pts_right_y,pts_right_z,"white");

%plot top
pts_top_x = r_vertices(1,[1,2,6,5]);
pts_top_y = r_vertices(2,[1,2,6,5]);
pts_top_z = r_vertices(3,[1,2,6,5]);
fill3(pts_top_x,pts_top_y,pts_top_z,"white");

%plot bottom
pts_bottom_x = r_vertices(1,[3,4,8,7]);
pts_bottom_y = r_vertices(2,[3,4,8,7]);
pts_bottom_z = r_vertices(3,[3,4,8,7]);
fill3(pts_bottom_x,pts_bottom_y,pts_bottom_z,"white");
hold off;

end