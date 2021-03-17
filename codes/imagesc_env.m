function imagesc_env(x,y,mat)
    imagesc(x,y,mat');
    set(gca,'YDir','normal');
end