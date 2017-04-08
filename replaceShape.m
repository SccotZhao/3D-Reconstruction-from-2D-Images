function object = replaceShape(object, shape)

cs = 1;
for k = 1:length(object)
    ce = cs + size(object(k).X, 2) - 1;
    object(k).X = shape(:, cs:ce);
    cs = ce + 1;
end