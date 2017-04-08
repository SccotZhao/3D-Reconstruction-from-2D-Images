function [G, P, scale] = rescale(G, P, scale)

if nargin < 3 || isempty(scale)
    scale = 1;
end

tau = G(1:3, 4);
ntau = norm(tau);

if ntau == 0
    error('Attempt to rescale with no translation')
end

scale = scale / ntau;

G(1:3, 4) = scale * tau;

if size(P, 1) == 4
    hc = true;
    P = euclidean(P);
else
    hc = false;
end

P = scale * P;
if hc
    P = homogeneous(P);
end