function [idx,C] = clusterdbscan(X,epsilon,minpts,seed)
% [idx,C] = clusterdbscan(X,epsilon,minpts,seed) returns the cluster ID idx
% for every data point and the centers of the clusters C using DBSCAN with
% the following input arguments:
% X: data (spike locations)
% epsilon (optional): a threshold for a neighborhood search radius
% minpts (optional): a minimum number of neighbors required to identify a core point
% seed (optional): seed for the random number generator
if nargin < 4
    seed = 1;   % for DBSCAN and shuffling
end
if nargin < 3
    minpts = floor(size(X,1)*0.01); % larger->stricter   
end
if nargin < 2
    epsilon = 6; % smaller->stricter or more clusters
end
rng(seed);
idx = dbscan(X,epsilon,minpts);
figure;
set(gcf,'Position',[0 0 1100 400]);
subplot(131); hold on; axis image;
plot(X(:,1),X(:,2),'k.'); title('all spikes');
subplot(132); hold on; axis image;
plot(X(idx==-1,1),X(idx==-1,2),'k.');
C = zeros(max(idx),2);
for j = unique(idx(idx~=-1))'
    C(j,:) = mean(X(idx==j,:));
    plot(X(idx==j,1),X(idx==j,2),'.');
    plot(C(j,1),C(j,2),'kx','LineWidth',2);
end
title(['DBSCAN: ',num2str(max(idx)),' clusters']);
subplot(133); hold on; axis image;
plot(X(idx~=-1,1),X(idx~=-1,2),'b.'); title('noise removed');
end