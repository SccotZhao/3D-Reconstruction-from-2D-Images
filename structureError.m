function e = structureError(P, Q, verbose)

P = euclidean(P);
Q = euclidean(Q);

% Center and scale the two sets of points
P = normalize(P);
Q = normalize(Q);

% Find rotation between the two sets of points
M = Q * P';
[U, ~, V] = svd(M);
D = eye(3);
D(3, 3) = sign(det(U*V'));
R = U * D * V';

% Rotate P
P = R * P;

% RMS discrepancy per point
e = norm(Q - P, 'fro') / sqrt(size(P, 2));

if verbose
    fprintf(1, 'Structure error: %.5g length units per point\n', e);
end

    function P = normalize(P)
        P = P - mean(P, 2) * ones(1, size(P, 2));
        scale = norm(P, 'fro');
        P = P / scale;
    end
end