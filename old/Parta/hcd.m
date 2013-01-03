%  Harris corner detector

function [cim, r, c] = hcd(im,thresh,sigma,radius)
   
    
    if ~isa(im,'double')
	im = double(im);
    end
    dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
    dy = dx';
    
    Ix = conv2(im, dx, 'same');    % Image derivatives
    Iy = conv2(im, dy, 'same');    

    g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
    
    Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');

     k = 0.04;
       cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; 
 	sze = 2*radius+1;                   
	mx = ordfilt2(cim,sze^2,ones(sze)); % For Non-maximal supression
	cim = (cim==mx)&(cim>thresh);       % Find maxima.

	[r,c] = find(cim);                  % Find row,col of non-zero elements
	imshow(uint8(im)), hold on
	 plot(c,r,'r+'), title('corners detected');
     
