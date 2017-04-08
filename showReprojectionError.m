function showReprojectionError(res1, res2, p1, p2, camera, img, which)

clf
pos = get(gcf, 'Position');
pos(3:4) = [840 630];
set(gcf, 'Position', pos);
set(gcf, 'NumberTitle', 'off', 'Name', ...
    sprintf('Reprojection Error %s', which));

K1 = camera(1).Ks * camera(1).Kf;
K2 = camera(2).Ks * camera(2).Kf;

showReprojectionError1(res1, p1, K1, camera(1).resolution, 1, 1, img);
showReprojectionError1(res2, p2, K2, camera(2).resolution, 3, 2, img);

    function showReprojectionError1(res, p, K, imgSize, sub, cam, img)
        
        pPixel = euclidean(K * p);
        p1Pixel = euclidean(K * homogeneous(euclidean(p) + res));
        res = p1Pixel - pPixel;
        
        % Scatterplot
        subplot(2, 2, sub)
        plot(res(1, :), res(2, :), 'xk');
        axis equal
        axis ij
        title(sprintf('Error scatterplot in image %d', cam))
        
        % Overlay
        subplot(2, 2, sub + 1)
        plot([0 imgSize(1) imgSize(1) 0 0], [0 0 imgSize(2) imgSize(2) 0], '-k');
        hold on
        drawPatches(img(:, cam));
        x = [pPixel(1, :); p1Pixel(1, :)];
        y = [pPixel(2, :); p1Pixel(2, :)];
        plot(x, y, 'r.', 'markersize' ,5)
        axis equal
        axis ij
        axis off
        title(sprintf('Error overlaid on image %d', cam));
    end
end