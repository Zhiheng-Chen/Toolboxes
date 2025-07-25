function plotSpring_3D(headCoords,tailCoords,phi,R_spr,N_coils,wireThickness,N_pts_coil)
%Zhiheng Chen
%2/5/2024

%calculate spring length
L_spr = norm(headCoords-tailCoords);

%find points
%-untransformed points
Deltaz = L_spr/N_coils;
[pts_x,pts_y] = calcPts_circle([0 0]',R_spr,N_pts_coil);
for ii = 1:N_coils-1
    pts_x = [pts_x,pts_x(1:N_pts_coil)];
    pts_y = [pts_y,pts_y(1:N_pts_coil)];
end
pts_z = linspace(-1/2*L_spr,1/2*L_spr,N_coils*N_pts_coil);

%-find homogeneous transformation matrix
psi = atan2(headCoords(2)-tailCoords(2),headCoords(1)-tailCoords(1));
R_psi = [cos(psi)   -sin(psi)   0
         sin(psi)   cos(psi)    0
         0          0           1];

L_proj = norm(headCoords(1:2)-tailCoords(1:2));   %length of the spring's projection on the xy plane
theta = atan(L_proj/(headCoords(3)-tailCoords(3)));
R_theta = [cos(theta)   0       sin(theta)
           0            1       0
           -sin(theta)  0       cos(theta)];

R_phi = [cos(phi)   -sin(phi)   0
         sin(phi)   cos(phi)    0
         0          0           1];

R_tot = R_psi*R_theta*R_phi;

r_C = (headCoords+tailCoords)/2;

HTM = [R_tot        r_C
       zeros(1,3)   1];

%transform points
for ii = 1:N_coils*N_pts_coil
    r_pt = [pts_x(ii) pts_y(ii) pts_z(ii) 1]';
    r_pt = HTM*r_pt;
    pts_x(ii) = r_pt(1);
    pts_y(ii) = r_pt(2);
    pts_z(ii) = r_pt(3);
end

%plot
plot3(pts_x,pts_y,pts_z,"color","k","lineWidth",wireThickness);

end