% Draw polygonal patches in 2 or 3 dimensions

function drawPatches(p)

for k = 1:length(p)
    if k == 1
        scale = 1;
        alpha = 1;
    else
        scale = 0.999;
        alpha = 0.1;
    end
    if isfield(p(k), 'X')
        r.Vertices = scale * euclidean(p(k).X)';
    else
        r.Vertices = scale * euclidean(p(k).x)';
    end
    r.Faces = p(k).faces;
    id = patch(r);
    set(id, 'FaceColor', 'flat', 'FaceAlpha', alpha, ...
        'FaceVertexCData', p(k).colors);
end