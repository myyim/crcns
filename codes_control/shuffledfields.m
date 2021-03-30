function gs = shuffledfields(g2d,thre,seed)
% gs = shuffledfields(g2d,thre,seed) shuffles grid bumps in g2d assuming that
% all bumps are identical and circular, and the partial fields at the edge
% do not matter. 
% Optional thre below which is considered zero for defining islands.
% Optional seed returns different realizations.
% Image processing toolbox is required
if nargin == 1
    thre = 0.2;
end
if nargin <= 2
    seed = 1;
end
g2d_small = g2d(g2d<=thre);
g2d(g2d<=thre) = 0;
rng(seed); 
[mp,n] = bwlabel(g2d);  % find the islands and the number
if n < 2
    error('Multiple isolated circular bumps separated by 0s are needed. Consider thresholding your data.');
end
mp(mp~=mode(mp(mp~=0),'all')) = 0; % pick the largest island and we want an intact one  
kern = g2d.*(mp~=0);    % a bump
kern(~any(kern,2),:) = [];  % remove rows with all zeros
kern(:,~any(kern,1)) = [];  % remove columns with all zeros
rkern = size(kern,1);
[xcoor,ycoor] = meshgrid(1:size(g2d,1),1:size(g2d,1)); % coordinates of the grid
xcoor = xcoor(:);   % flatten it
ycoor = ycoor(:);
fc = zeros(size(g2d));  % matrix for field centers
for j = 1:n
    c = datasample([xcoor,ycoor],1);    % draw the center of the bump but potential center coordinates
    fc(c(1),c(2)) = 1;  % field centers
    fclogical = logical(sqrt((xcoor-c(1)).^2+(ycoor-c(2)).^2)>=rkern); % potential field centers; modify for overlapping or stricter constraint
    %fclogical = logical((abs(xcoor-c(1))>=rkern)+(abs(ycoor-c(2))>=rkern)); % for square-shaped constraint
    xcoor = xcoor(fclogical); % remove the field center and its surrounding from the list
    ycoor = ycoor(fclogical);
end
gs = conv2(fc,kern,'same'); % convolve the field centers with the field kernel
randmat = randsample(g2d_small,numel(g2d),'true');  % a random matrix following the statistics of below-threshold values
gs = gs + reshape(randmat,size(g2d)).*(gs==0); % fill the gap
figure; hold on; axis image; colorbar; colormap(jet(256));imagesc(gs');
end
