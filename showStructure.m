% View the scene structure in s

function showStructure(s, which)

clf
set(gcf, 'NumberTitle', 'off', 'Name', which);

drawPatches(s);

axis equal
axis off
rotate3d on