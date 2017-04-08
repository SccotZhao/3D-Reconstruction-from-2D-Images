function c = camera(t, X, resolution, sensorSize)

if any(t < 0)
    error('The camera must be in the first octant')
end

% Rigid transformation for a camera at t that looks toward the origin of
% the world and has the focal distance needed to keep the object in the
% field of view
k = -t / norm(t);
i = cross(k, [0 0 1]');
i = i / norm(i);
j = cross(k, i);
if j(3) > 0
    i = -i;
    j = -j;
end
R = [i j k]';
G = [R, -R * t; zeros(1, 3), 1];

% Image part of the intrinsic calibration matrix
principalPoint = round(resolution / 2);
sx = resolution(1) / sensorSize(1);
sy = resolution(2) / sensorSize(2);
Ks = [sx 0 principalPoint(1); 0 sy principalPoint(2); 0 0 1];

Pi = [eye(3) zeros(3, 1)];

% Find a good focal length
margin = 0.05;
signFlip = [-1 0; 0 1];
x = euclidean(Pi * G * X);
objectCorners = [min(x, [], 2) max(x, [], 2)] * signFlip;
imageCorners = (1 - margin) * ...
    euclidean(Ks \ homogeneous([1 1; resolution]')) * signFlip;

objectCorners = objectCorners(:);
imageCorners = imageCorners(:);
pos = objectCorners > 0;
ratio = Inf(size(objectCorners));
ratio(pos) = imageCorners(pos) ./ objectCorners(pos);
f = min(ratio);

% Rest of the intrinsic calibration matrix
Kf = eye(3);
Kf(1, 1) = f;
Kf(2, 2) = f;

c.resolution = resolution;
c.G = G;
c.Ks = Ks;
c.Kf = Kf;
c.P = Ks * Kf * Pi * G;