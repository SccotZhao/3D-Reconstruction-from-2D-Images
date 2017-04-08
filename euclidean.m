function e = euclidean(h)

w = h(end, :);
d = size(h, 1) - 1;
e = h(1:d, :);

nz = w ~= 0;
e(:,  nz) = h(1:d, nz) ./ (ones(d, 1) * w(nz));