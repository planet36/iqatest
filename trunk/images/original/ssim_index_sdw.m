## Copyright (C) 2011 Steve Ward

# This is an implementation of the algorithm for calculating the
# Structural SIMilarity (SSIM) index between two images. Please refer
# to this paper:
# "Image Quality Assessment: From Error Visibility to Structural Similarity"
# by Zhou Wang, Alan Conrad Bovik, Hamid Rahim Sheikh, Eero P. Simoncelli
# IEEE Transactions on Image Processing, Vol. 13, No. 4, April 2004
#
# The original implementation was created by <zhouwang@ieee.org>.
#
#
# Input : (1) img1: the first image
#
#         (2) img2: the second image
#
#         (3) (optional) K: constants in the SSIM index formula (see the above
#             reference). default value: K = [0.01 0.03]
#
#         (4) (optional) window: local window for statistics (see the above
#             reference). default value: fspecial('gaussian', 11, 1.5);
#
# Output: (1) mssim: the mean SSIM index value between 2 images.
#             If one of the images being compared is regarded as
#             perfect quality, then mssim can be considered as the
#             quality measure of the other image.
#             If img1 = img2, then mssim = 1.
#
#         (2) ssim_map: the SSIM index map of the test image. The map
#             has a smaller size than the input images. The actual size:
#             size(img1) - size(window) + 1.


function [mssim, ssim_map] = ssim_index_sdw(
	img1, img2, K = [0.01 0.03], window = fspecial('gaussian', 11, 1.5))


# the default return values
mssim = -Inf;
ssim_map = -Inf;


# only 2, 3, or 4 args may be given
if (nargin < 2 || nargin > 4)
	return;
end


# convert a color image to gray-scale
if (isrgb(img1))
	img1 = rgb2gray(img1);
end


# convert a color image to gray-scale
if (isrgb(img2))
	img2 = rgb2gray(img2);
end


# the images must be gray-scale
if (!isgray(img1) || !isgray(img2))
	return;
end


# the images must be the same size
if (size(img1) != size(img2))
	return;
end


# the size of the images must be at least the size of the window
if (any(size(img1) < size(window)))
	return
end


# the size of the window must be at least [2 2]
if (any(size(window) < 2))
	return
end


# the images must be different
if (img1 == img2)
	mssim = 1;
	ssim_map = ones(size(img1));
	return;
end


# K must be an array of length 2
if (numel(K) != 2)
	return;
end


# K must be >= 0 and << 1
if (any(K < 0) || any(K >= 0.1))
	return;
end


# normalize the window
# if the window is always a gaussian, this step is unnecessary

window_sum = sum(sum(window));


if (window_sum == 0)
	return;
end


if (window_sum != 1)
	window /= window_sum;
end


# convert the images to double
img1 = im2double(img1);
img2 = im2double(img2);


C = K .^ 2;


#-------------------------------------------------------------------------------


# uses 'valid' in the filter

mu1 = filter2(window, img1, 'valid');
mu2 = filter2(window, img2, 'valid');

mu1_sq = mu1 .^ 2;
mu2_sq = mu2 .^ 2;

mu1_mu2 = mu1 .* mu2;

sigma1_sq = filter2(window, img1 .^ 2, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2 .^ 2, 'valid') - mu2_sq;

sigma12 = filter2(window, img1 .* img2, 'valid') - mu1_mu2;


#-------------------------------------------------------------------------------


# uses 'same' in the filter

#mu1 = filter2(window, img1);
#mu2 = filter2(window, img2);

#mu1_sq = mu1 .^ 2;
#mu2_sq = mu2 .^ 2;

#mu1_mu2 = mu1 .* mu2;

#sigma1_sq = filter2(window, (img1 - mu1) .^ 2);
#sigma2_sq = filter2(window, (img2 - mu2) .^ 2);

#sigma12 = filter2(window, (img1 - mu1) .* (img2 - mu2));


#-------------------------------------------------------------------------------


numerator1 = 2 * mu1_mu2 + C(1);

numerator2 = 2 * sigma12 + C(2);

denominator1 = mu1_sq + mu2_sq + C(1);

denominator2 = sigma1_sq + sigma2_sq + C(2);

ssim_map = (numerator1 .* numerator2) ./ (denominator1 .* denominator2);


mssim = mean2(ssim_map);


endfunction
