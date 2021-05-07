function spts = shuffledclusters(X,idx,seed,mask)
% spts = shuffledclusters(X,idx,seed,mask) shuffles clusters and returns
% the shuffled data points spts.
% Optional seed returns different realizations.
% Optional mask defines the boundary for shuffled fields.
% By default the environment centers at the origin.
dmax = ceil(max(abs(X),[],'all'));
if nargin < 4  
    mask = ones(2*dmax+1,2*dmax+1); % minimum environment containing all data
end
if nargin < 3
    seed = 1;
end
if 2*max(abs(X(:,1)))+1 > size(mask,1) || 2*max(abs(X(:,2)))+1 > size(mask,2)
    error('Use a mask of larger dimension!');
end
maxiter = 1000;
rng(seed); 
xm = floor(size(mask,1)/2); % the mask matrix is rectangular
ym = floor(size(mask,2)/2);
[ycoor,xcoor] = meshgrid(-ym:ym,-xm:xm); % coordinates of the grid. Note g2d is y by x
figure; hold on; axis image;
spts = [];
for j = 1:max(idx)
    loc = hist3(X(idx==j,:),'Edges',{-xm:xm,-ym:ym});
    xtemp = (loc>0).*xcoor; xmax = max(xtemp,[],'all'); % find the smallest rectangle that contains the cluster
    xtemp(xtemp==0)=1e10; xmin = min(xtemp,[],'all');
    ytemp = (loc>0).*ycoor; ymax = max(ytemp,[],'all');
    ytemp(ytemp==0)=1e10; ymin = min(ytemp,[],'all');    
    count = 0;
    while count==0 || sum(loc,'All')~=sum(proj.*mask,'All') % ensure all data points in the allowed region
        if count > maxiter
            error('A field does not fit in the shuffled environment. Consider using a larger environment.')
        end         
        shift = [-xmin-xm+(2*xm-xmax+xmin)*rand(1),-ymin-ym+(2*ym-ymax+ymin)*rand(1)];        
        proj = hist3(X(idx==j,:)+shift,'Edges',{-xm:xm,-ym:ym});
        count = count + 1;
    end
    mask(proj>0) = 0; % restrict overlapping clusters
    plot(X(idx==j,1)+shift(1),X(idx==j,2)+shift(2),'.');
    spts = [spts; X(idx==j,:)+shift]; % assign the field to the new location    
end
% fill the empty space with background statistics
noise = [-xm+2*xm*rand(sum(idx==-1),1) -ym+2*ym*rand(sum(idx==-1),1)];
spts = [spts; noise];
plot(noise(:,1),noise(:,2)); xlim([-dmax,dmax]); ylim([-dmax,dmax]);
end