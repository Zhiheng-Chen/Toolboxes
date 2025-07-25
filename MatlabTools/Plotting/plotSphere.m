function plotSphere(R,HTM)
%Zhiheng Chen
%2/12/2024

%find transformed grids
[grids_x,grids_y,grids_z] = sphere;
grids_x = R*grids_x;
grids_y = R*grids_y;
grids_z = R*grids_z;

for ii = 1:size(grids_x,1)
    for jj = 1:size(grids_x,2)
        r_grid = [grids_x(ii,jj) grids_y(ii,jj) grids_z(ii,jj) 1]';
        r_grid = HTM*r_grid;
        r_grid = r_grid(1:3);
        grids_x(ii,jj) = r_grid(1);
        grids_y(ii,jj) = r_grid(2);
        grids_z(ii,jj) = r_grid(3);
    end
end

%plot
surf(grids_x,grids_y,grids_z,"faceColor","white");

end