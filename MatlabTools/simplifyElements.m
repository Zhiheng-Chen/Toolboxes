function M_out = simplifyElements(M_in)
%Zhiheng Chen
%created: 7/18/2023

for ii = 1:size(M_in,1)
    for jj = 1:size(M_in,2)
        M_out(ii,jj) = expand(simplify(M_in(ii,jj)));
    end
end