function [idx,C] = clusterkmeans(X,idx0,seed)
% [idx,C] = clusterkmeans(X,idx0,C0,seed) returns the cluster ID idx for every
% data point and the centers of the clusters C using k-means with the 
% following input arguments:
% X: data (filtered spike locations)
% idx0: IDs of the clusters from DBSCAN
% seed (optional): seed for the random number generator
if nargin < 3
    seed = 1; 
end
rng(seed);
C0 = zeros(max(idx0),2);
for j = unique(idx0(idx0~=-1))'
    C0(j,:) = mean(X(idx0==j,:));
end
Y = X(idx0~=-1,:);
figure;
set(gcf,'Position',[0 0 1100 400]);
subplot(131); hold on; axis image;
plot(X(:,1),X(:,2),'k.'); title('all spikes');
subplot(132); hold on; axis image;
idx = kmeans(Y,size(C0,1));
C = zeros(max(idx),2);
for j = unique(idx(idx~=-1))'
    C(j,:) = mean(Y(idx==j,:));
    plot(Y(idx==j,1),Y(idx==j,2),'.');
    plot(C(j,1),C(j,2),'kx','LineWidth',2);
end
title(['k-means: ',num2str(max(idx)),' clusters']);
subplot(133); hold on; axis image;
id = kmeans(Y,size(C0,1),'Start',C0);
C = zeros(max(id),2);
for j = unique(id(id~=-1))'
    C(j,:) = mean(Y(id==j,:));
    plot(Y(id==j,1),Y(id==j,2),'.');
    plot(C(j,1),C(j,2),'kx','LineWidth',2);
end
idx = -ones(size(idx0));
k = 1;
for j = 1:size(idx0,1)
    if idx0(j) ~= -1
        idx(j) = id(k);
        k = k + 1;
    end
end
title(['k-means with centers: ',num2str(max(idx)),' clusters']);
end