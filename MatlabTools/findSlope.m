function m = findSlope(data_x,data_y)
%Zhiheng Chen
%created: 9/2/2023
%this function finds the slope of a linear curve fit that passes through
%the origin

m = sum(data_x.*data_y)/sum(data_x.^2);

end