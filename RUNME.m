% Simple experiment on reconstruction accuracy using a synthetic world and
% the Longuet-Higgins eight-point algorithm

% Do we want to see images and reconstruction errors?
verbose = true;

% Side length of a cubic box
side = 210;
totalEImg=[];
totalEP=[];
totalER=[];
totalEt=[];

for height=250:250
% Camera positions in the frame of reference of the box
distance = 500;
t = distance * [unit([0.9 1 1]); unit([1.1 1 1])]';

% Make a 3D box, two cameras, and the resulting images

s=3;
    
[box, camera, img] = world(side,height, t,s);

% Add zero-mean Gaussian noise to the images
sigma =0.21; % Standard deviation of noise, in pixels

img = addNoise(img, sigma);

fig = 1;
if verbose
    fprintf(1, 'Image noise standard deviation %.2g pixels\n', sigma);
    
%     Display the images
    showImages(img, camera, fig);
    fig = fig + 2;
end

% Compute the true transformation between the camera reference frames
G = camera(2).G / camera(1).G;

% True structure
X = [box(1).X, box(2).X];

% Compute image coordinates in the canonical reference frame
K1 = camera(1).Ks * camera(1).Kf;
K2 = camera(2).Ks * camera(2).Kf;
x1 = K1 \ [img(1, 1).x, img(2, 1).x];
x2 = K2 \ [img(1, 2).x, img(2, 2).x];

% Compute the transformation between the reference systems of the two
% cameras and the scene structure in the first camera reference system,
% using the eight-point algorithm
[GComputed, XComputed] = longuetHiggins(x1, x2);

% Measure and report errors before bundle adjustment
fprintf(1, '\nAfter running the eight-point algorithm:\n');
[eR, et] = motionError(GComputed, G, verbose);
eP = structureError(XComputed, X, verbose);
[eImg, e1, e2] = reprojectionError(GComputed, XComputed, ...
    x1, x2, camera, verbose);

totalEImg=[totalEImg,eImg];
totalER=[totalER,eR];
totalEt=[totalEt,et];
totalEP=[totalEP,eP];
% Display reprojection errors
figure(fig)
showReprojectionError(e1, e2, x1, x2, camera, img, ...
    'With the eight-point algorithm');

% Display true and reconstructed scene structure in world coordinates
boxComputed = replaceShape(box, camera(1).G \ XComputed);


end
fig = fig + 1;
figure(fig)
showStructure(box, 'True Structure');

fig = fig + 1;
figure(fig)
showStructure(boxComputed, 'Reconstructed Structure');

placeFigures
