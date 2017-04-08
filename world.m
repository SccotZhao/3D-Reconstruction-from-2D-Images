function [b, c, img] = world(side,height, t,s)

resolution = [1920 1080];   % pixels
sensorSize = [8 4.5];       % mm

% Homogeneous coordinates of the corners of the squares on a calibration
% box, in mm

   b = box(side,height,s);


% Make projection and calibration matrices for a camera at t that looks
% towards the origin of the world

nCameras = size(t, 2);

for k = 1:nCameras
    c(k) = camera(t(:, k), b(2).X, resolution, sensorSize);
    img(:, k) = project(b, c(k)); %#ok<*AGROW>
end

% Scale everything to camera translation magnitude
G = c(2).G / c(1).G;
[~, b(1).X, scale] = rescale(G, b(1).X);
b(2).X = homogeneous(scale * euclidean(b(2).X));
Pi = [eye(3), zeros(3, 1)];
for k = 1:nCameras
    c(k).G(1:3, 4) = scale * c(k).G(1:3, 4);
    c(k).P =  c(k).Ks * c(k).Kf * Pi * c(k).G;
end