% Compute an (if verbose is true) report errors between two transformation
% matrices in homogeneous coordinates.

function [eR, et] = motionError(G1, G2, verbose)

if nargin < 3 || isempty(verbose)
    verbose = false;
end

G1 = normalize(G1);
G2 = normalize(G2);

% Rotation error measured as the angle in degrees of the deviation of
% R1'*R2 from the identity transformation
R1 = G1(1:3, 1:3);
R2 = G2(1:3, 1:3);
eR = norm(rodrigues(R1'*R2)) * 180 / pi;

% Translation error measured as the angle in degrees between the two
% translation vectors
t1 = unit(-R1' * G1(1:3, 4));
t2 = unit(-R2' * G2(1:3, 4));
et = acos(t1'*t2) * 180 / pi;

if verbose
    fprintf(1, 'Rotation error: %.5g degrees\n', eR);
    fprintf(1, 'Translation error: %.5g degrees\n', et);
end

    function Gn = normalize(G)
        if G(4, 4) == 0
            error('Last entry in a transformation matrix cannot be zero');
        end
        Gn = G / G(4, 4);
    end

end