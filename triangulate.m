function [X, Y] = triangulate(x, y, G)

n = size(x, 2);

Pi = [eye(3), zeros(3, 1)];
Phi = Pi * G;

X = zeros(4, n);

for i=1:n
    A = [x(1, i) * Pi(3, :) - Pi(1, :);
         x(2, i) * Pi(3, :) - Pi(2, :);
         y(1, i) * Phi(3, :) - Phi(1, :);
         y(2, i) * Phi(3, :) - Phi(2, :)];
     
  
     [~, ~, v] = svd(A);
    X(:, i) = v(:,4);
end

Y = G * X;

% Normalize fourth coordinate
X = homogeneous(euclidean(X));
Y = homogeneous(euclidean(Y));