%Take connected components and make a line approximation in point-slope form

function [m b] = comp_to_line(CC)
	props = regionprops(CC, 'Centroid', 'Orientation');

	orientations = 3.14159/180.*cat(1, props.Orientation);
	centroids = cat(1, props.Centroid);
	m = -1.*arrayfun(@tan, orientations);
	b = centroids(:, 2) - m.*centroids(:, 1);

end

