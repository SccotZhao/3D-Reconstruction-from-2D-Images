function [e, e1, e2] = reprojectionError(G, P, p1, p2, camera, verbose)

K1 = camera(1).Ks * camera(1).Kf;
K2 = camera(2).Ks * camera(2).Kf;

% Euclidean coordinates of all the 3D points and image points
P = euclidean(P);
img1 = euclidean(p1);
img2 = euclidean(p2);

[e1, e2] = reprojectionErrors(G, P, img1, img2);

% Scale residuals to pixels, but do not translate
res1 = K1(1:2, 1:2) * e1;
res2 = K2(1:2, 1:2) * e2;

% RMS reprojection error per point
n = size(res1, 2);
e = norm([res1, res2], 'fro') / sqrt(2*n);

if verbose
    fprintf(1, 'Reprojection error: %.5g pixels per point\n', e);
end

    function [e1, e2] = reprojectionErrors(G, P, img1, img2)
        R2 = G(1:3, 1:3);
        t2 = -R2' * G(1:3, 4);
        R1 = eye(3);
        t1 = zeros(3, 1);
        e1 = re(R1, t1, P, img1);
        e2 = re(R2, t2, P, img2);
        
        function e = re(R, t, P, p)
            ex = re1(R([1 3], :), t, P, p(1, :));
            ey = re1(R([2 3], :), t, P, p(2, :));
            e = [ex; ey];
            
            function e = re1(R, t, P, p)
                T = t * ones(1, size(P, 2));
                num = R(1, :) * (P - T);
                den = R(2, :) * (P - T);
                e = (num ./ den - p);
                e = e(:)';
            end
        end
    end

end