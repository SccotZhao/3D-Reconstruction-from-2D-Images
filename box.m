% Make a cubic box with calibration squares on it.
% The output structure b contains a 4 by n matrix b.X with the homogeneous
% coordinates of the corners of the squares on a cubic calibration box.
% The box has the given side length in mm, and there
% are s by s equi-spaced squares on each side of the box, so that
% n = 4 * s * s * 3 (because there are 3 visible sides).
% The array b.square describes the connectivity between points in b.X, and
% % b.colors specifies face colors.
% The two arrays b.B and b.face play similar roles for the visible corners
% of the cube

function bx = box(side,height, s)

if nargin < 1 || isempty(side)
    side = 140;
end

if nargin < 2 || isempty(height)
    height = 140;
end
if nargin < 3 || isempty(s)
    s = 3;
end

c = 2 * s;    % Number of corners in each line
pitchSide = side / (c + 1);
sequenceSide = linspace(pitchSide, c*pitchSide, c);
pitchHeight = height / (c + 1);
sequenceHeight = linspace(pitchHeight, c*pitchHeight, c);

x1 = side * ones(c, c);
y1 = ones(c, 1) * sequenceSide;
z1 = sequenceHeight' * ones(1, c);
X = [x1(:) y1(:) z1(:)];

x2 = y1;
y2 = x1;
z2 = z1;
X = [X; [x2(:) y2(:) z2(:)]];

x3 = y1;
y3 = sequenceSide' * ones(1, c);
z3 = x1*height/side;
X = [X; [x3(:) y3(:) z3(:)]];

% Homogeneous coordinates and transpose
X = [X ones(size(X, 1), 1)]';

% Adjacency matrix that defines the square patches
b = (1:2:(c-1))';
square = [];
for k = 1:s
    square = [square; ...
        2 * c * (k - 1) + [b, b + c, b + c + 1, b + 1, b]]; %#ok<AGROW>
end

square = [square; square + c^2; square + 2 * c^2];

% Homogeneous coordinates of the visible corners of the box
B = side * [1 0 0; 1 0 height/side; 0 0 height/side; 0 1 height/side; 0 1 0; 1 1 0; 1 1 height/side];
B = [B ones(size(B, 1), 1)]';

% Box adjacency matrix
face = [1 2 7 6 1; 6 7 4 5 6; 2 3 4 7 2];

bx(1, :).X = X;
bx(1, :).faces = square;
bx(1, :).colors = ones(size(square, 1), 1) * [1 1 0.8];
bx(2, :).X = B;
bx(2, :).faces = face;
bx(2, :).colors = ones(3, 1) * 0.4 * [1 1 1];

