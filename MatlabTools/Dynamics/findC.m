function C = findC(X,M)
%Zhiheng Chen
%created: 8/28/2023
%this function finds the Coriolis/centrifugal matrix given the state
%space and the mass/inertia matrix

q = X(1:length(X)/2);
q_dot = X(length(X)/2+1:end);

C = sym(zeros(length(q),length(q)));
for ii = 1:length(q)
    for jj = 1:length(q)
        for kk = 1:length(q)
            C(ii,jj) = C(ii,jj)+(diff(M(ii,jj),q(kk))-0.5*diff(M(jj,kk),q(ii)))*q_dot(kk);
        end
    end
end
C = simplifyElements(C);

end