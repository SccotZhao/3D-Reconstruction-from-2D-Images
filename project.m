% Takes an object and a camera, and projects the object onto the camera.
% The object is either a 4 by n array of homogeneous coordinates of 3D
% points, or is a vector of structures that define vertices, faces, and
% colors of patches, as produced for instance by box.m

function img = project(object, c)

% object is a 4 by n array of points. Project onto the given camera
if ~isstruct(object)
    if size(object, 1) ~= 4
        error('Input must be either a structure or a 4 by n array')
    end
    
    img = homogeneous(euclidean(c.P * object));
else
    img = struct('x', [], 'faces', cell(size(object)), 'colors', []);
    for k = 1:length(object)
        img(k).x = project(object(k).X, c);
        img(k).faces = object(k).faces;
        img(k).colors = object(k).colors;
    end
end