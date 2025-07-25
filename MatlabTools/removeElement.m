function vec_out = removeElement(vec_in,index)
%Zhiheng Chen
%created: 9/14/2023
%this function removes the element corresponding to the given index from a given 1D array

vec_out = [vec_in(1:index-1),vec_in(index+1:end)];

end