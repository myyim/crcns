function gs = shuffledbins(g2d,seed)
% gs = shuffledbins(g2d,seed) shuffles pixels in g2d.
% Optional seed returns different realizations.
if nargin == 1
    seed = 1;
end
rng(seed); 
gs = reshape(g2d(randperm(numel(g2d))),size(g2d));
figure; hold on; axis image; colorbar; colormap(jet(256));imagesc_env(gs);
end