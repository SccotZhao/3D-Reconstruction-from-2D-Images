% Add random zero-mean Gaussian noise with standard deviation sigma
% to the given images

function img = addNoise(img, sigma)

for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        x = euclidean(img(i, j).x);
        x = x + sigma * randn(size(x));
        img(i, j).x = homogeneous(x);
    end
end