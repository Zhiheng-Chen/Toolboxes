function plotCylinder(H,R,HTM,N_plot)
%Zhiheng Chen
%2/12/2024

%plot top
[pts_X_top,pts_Y_top] = calcPts_circle([0 0]',R,N_plot);
pts_Z_top = H/2.*ones(1,N_plot);
for ii = 1:N_plot
    r_pt = HTM*[pts_X_top(ii) pts_Y_top(ii) pts_Z_top(ii) 1]';
    r_pt = r_pt(1:3);
    pts_X_top(ii) = r_pt(1);
    pts_Y_top(ii) = r_pt(2);
    pts_Z_top(ii) = r_pt(3);
end
plot3(pts_X_top,pts_Y_top,pts_Z_top,"color",[1,1,1]);
grid on;
hold on;
fill3(pts_X_top,pts_Y_top,pts_Z_top,[1,1,1]);

%plot bottom
[pts_X_bottom,pts_Y_bottom] = calcPts_circle([0 0]',R,N_plot);
pts_Z_bottom = -H/2.*ones(1,N_plot);
for ii = 1:N_plot
    r_pt = HTM*[pts_X_bottom(ii) pts_Y_bottom(ii) pts_Z_bottom(ii) 1]';
    r_pt = r_pt(1:3);
    pts_X_bottom(ii) = r_pt(1);
    pts_Y_bottom(ii) = r_pt(2);
    pts_Z_bottom(ii) = r_pt(3);
end
plot3(pts_X_bottom,pts_Y_bottom,pts_Z_bottom,"color",[1,1,1]);
fill3(pts_X_bottom,pts_Y_bottom,pts_Z_bottom,[1,1,1]);

%plot body
for ii = 1:N_plot-1
    pts_X_body = [pts_X_top(ii),pts_X_top(ii+1),pts_X_bottom(ii+1),pts_X_bottom(ii)];
    pts_Y_body = [pts_Y_top(ii),pts_Y_top(ii+1),pts_Y_bottom(ii+1),pts_Y_bottom(ii)];
    pts_Z_body = [pts_Z_top(ii),pts_Z_top(ii+1),pts_Z_bottom(ii+1),pts_Z_bottom(ii)];
    fill3(pts_X_body,pts_Y_body,pts_Z_body,[1,1,1]);
end

hold off;

end