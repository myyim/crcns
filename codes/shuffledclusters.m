function spts = shuffledclusters(X,idx,seed,mask)
% spts = shuffledclusters(X,idx,seed,mask) shuffles clusters and returns
% the data points of the shuffled clusters.
% Optional seed returns different realizations.
% Optional mask defines the boundary for shuffled fields.
dmin = floor(min(X));
X1 = X + dmin;
if nargin < 4
    mask = ones(ceil(max(X1))); % minimum environment containing all data
end
if nargin < 3
    seed = 1;
end
if max(X1) > size(mask)
    error('Use a mask of larger dimension!');
end
maxiter = 1000;
mask0 = mask;
rng(seed); 
%[ycoor,xcoor] = meshgrid(1:size(mask,2),1:size(mask,1)); % coordinates of the grid. Note g2d is y by x. 
for j = 1:max(idx)
    xtemp = (idx==j).*xcoor; xmax = max(xtemp,[],'all'); % find the smallest rectangle that contains the cluster
    xtemp(xtemp==0)=1e10; xmin = min(xtemp,[],'all');
    ytemp = (idx==j).*ycoor; ymax = max(ytemp,[],'all');
    ytemp(ytemp==0)=1e10; ymin = min(ytemp,[],'all');
    count = 0;
    while count==0 || sum(sum(idx==j))~=sum(sum((proj>0).*mask)) % restrict the new field using the mask
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