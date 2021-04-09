function spts = shuffledclusters(pts,epsilon,minpts,k,seed,mask)
% gs = shuffledclusters() shuffles clusters.
% Optional seed returns different realizations.
% Optional mask defines the boundary for shuffled fields.
% Image processing toolbox is required.
if nargin == 1
    thre = 0.2;
end
if nargin <= 2
    seed = 1;
end
if nargin <= 3
    mask = ones(size(g2d));
end
if sum(size(g2d) ~= size(mask))
    error('The mask should have the same size as the input matrix.')
end
maxiter = 1000;
mask0 = mask;
gthre = thre*max(g2d,[],'all');
g2d_small = g2d((g2d<=gthre).*mask0>0);
g2d(g2d<=gthre) = 0;
rng(seed); 
[mp,n] = bwlabel(g2d);  % find the islands and the number
if n < 2
    error('Multiple isolated circular bumps separated by 0s are needed. Consider thresholding your data.');
end
gs = zeros(size(g2d));
[ycoor,xcoor] = meshgrid(1:size(g2d,2),1:size(g2d,1)); % coordinates of the grid. Note g2d is y by x. 
for j = 1:n
    xtemp = (mp==j).*xcoor; xmax = max(xtemp,[],'all'); % find the smallest rectangle that contains the island
    xtemp(xtemp==0)=1e10; xmin = min(xtemp,[],'all');
    ytemp = (mp==j).*ycoor; ymax = max(ytemp,[],'all');
    ytemp(ytemp==0)=1e10; ymin = min(ytemp,[],'all');
    count = 0;
    while count==0 || sum(sum(mp==j))~=sum(sum((proj>0).*mask)) % restrict the new field using the mask
        if count > maxiter
            error('A field does not fit in the shuffled environment. Consider using a larger environment.')
        end
        select = (mask==1).*(xcoor<max(xcoor,[],'all')-xmax+xmin).*(ycoor<max(ycoor,[],'all')-ymax+ymin);
        newcorner = datasample([xcoor(select==1) ycoor(select==1)],1); % coordinates of the lower corner to place the field
        proj = zeros(size(g2d));
        proj(newcorner(1):newcorner(1)+xmax-xmin,newcorner(2):newcorner(2)+ymax-ymin) = g2d(xmin:xmax,ymin:ymax);
        count = count + 1;
    end
    mask(proj>0) = 0; % update the mask
    gs = gs + proj; % assign the field to the new location    
end
% fill the empty space with background statistics
randmat = randsample(g2d_small,numel(g2d),'true');  % a random matrix following the statistics of below-threshold values
gs = gs + reshape(randmat,size(g2d)).*(gs==0); % fill the gap
gs = gs.*mask0;
figure; hold on; axis image; colorbar; colormap(jet(256));imagesc_env(gs);
end
