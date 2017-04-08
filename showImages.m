% Display the images in img, assumed to be taken with the cameras in c.
% There should be one camera per image

function showImages(img, c, fig)

n = length(c);
if size(img, 2) ~= n
    error('The number of images must equal the number of cameras')
end

for i = 1:n
    % Make a new, clean figure
    figure(fig + i - 1)
    clf
    
    % Draw the image frame
    res = c(i).resolution;
    plot([0 res(1) res(1) 0 0], [0 0 res(2) res(2) 0], '-k');
    hold on
    
    % Draw the image contents
    drawPatches(img(:, i));
    
    % Set figure axes and title
    axis ij
    axis equal
    axis off
    set(gcf, 'NumberTitle', 'off', 'Name', ...
        sprintf('View From Camera %d', i));
end