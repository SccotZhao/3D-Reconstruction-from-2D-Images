% A version of H. C. Longuet-Higgins's so-called eight-point algorithm
% ("A computer algorithm for reconstructing a scene from two projections",
% Nature 293(5828):133). This version is simplified through reasoning with
% SVD and null spaces
%
% The input matrices x and y are 3 by n. Each column contains the canonical
% homogeneous coordinates of one of the n points in one of the two images.
% Point x(:, k) is assumed to correspond to point y(:, k).
%
% The output G is a homogeneous representation of the
% rigid transformation between camera 1 and camera 2.
% The translation t has unit length.
% The output X is a 4 by n matrix that contains the homogeneous
% coordinates of the points in space in the frame of reference of the
% first camera.
% The output Y is G * X
%
% The code below uses the functions skew and compute3DStructure from
% http://cs.gmu.edu/%7Ekosecka/bookcode.html

function [G, X, Y]  = longuetHiggins(x, y)

% Number of point correspondences
n = size(x, 2);

if size(y, 2) ~= n
    error('The number of points in the two images must be the same');
end

% Set up matrix A such that A*E(:) = 0, where E is the essential matrix.
% This system encodes the epipolar constraint y' * E * x = 0 for each of
% the points x and y
A = zeros(n, 9);
for i = 1:n
    A(i,:) = kron(x(:,i),y(:,i))';
end

if rank(A) < 8
    error('Measurement matrix rank deficient')
end;

% The singular vector corresponding to the smallest singular value of A
% is the arg min_{norm(e) = 1} A * e, and is the LSE estimate of E(:)
[~, ~, V] = svd(A);
E = reshape(V(:,9), 3, 3);

% The two possible translation vectors are t and -t, where t is a unit
% vector in the null space of E. The vector t (or -t) is also the
% second epipole of the camera pair
[~, ~, VE] = svd(E);
t = VE(:, 3);

% Two rotation matrix choices are found by solving the Procrustes problem
% for the rows of E and skew(t), and allowing for the ambiguity resulting
% from the sign of the null-space vectors (both E and skew(t) are rank 2).
% These two choices are independent of the sign of t, because both E and -E
% are essential matrices
tx = skew(t);
[UR, ~, VR] = svd(E * tx);
R1 = UR * VR';
R1 = R1 * det(R1);
UR(:, 3) = -UR(:, 3);
R2 = UR * VR';
R2 = R2 * det(R2);

% Combine the two sign options for t with the two choices for R
t = [t, t, -t, -t];
R = cat(3, R1, R2, R1, R2);

% Pick the combination of t and R that yields the greatest number of
% positive depth (Z) values in the structure results for the frames of
% reference of both cameras. Ideally, all depth values should be positive
npd = zeros(4, 1);
X = zeros(4, n, 4);
Y = zeros(4, n, 4);
for k = 1:4
    G = [R(:, :, k), -R(:, :, k) * t(:, k); 0 0 0 1];
    [X(:, :, k), Y(:, :, k)] = triangulate(x, y, G);
    npd(k) = sum(X(3, :, k) > 0 & Y(3, :, k) > 0);
end
[~, best] = max(npd);
G = [R(:, :, best), -R(:, :, best) * t(:, best); 0 0 0 1];
X = X(:, :, best);
Y = Y(:, :, best);