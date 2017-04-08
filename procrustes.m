% Find a rigid transformation g in homogeneous coordinates that minimizes
% norm(g*P - Q)

function G = procrustes(P, Q)

P = euclidean(P);
Q = euclidean(Q);

p = mean(P, 2);
q = mean(Q, 2);

P = P - p * ones(1, size(P, 2));
Q = Q - q * ones(1, size(Q, 2));

M = Q * P';
[U, ~, V] = svd(M);
D = eye(3);
D(3, 3) = sign(det(U*V'));
R = U * D * V';

t = q - R * p;

G = [R, -R*t; zeros(1, 3), 1];