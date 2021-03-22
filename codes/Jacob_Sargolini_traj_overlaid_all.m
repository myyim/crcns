clear all; close all;

%% parameters
p_guess = [100,100,100]; 
t = 0:0.05:2*pi+0.05;

%% set path and get directories
run('Jacob_Sargolini_Data_param.m');

%% 
for j = 1:71    % filenames
    [trackpos,trackf,ts] = getdata_sargolini(CellIDarena{j,1},CellIDarena{j,2},CellIDarena{j,3},0);
    [trackpos1,trackf1,ts1] = getdata_sargolini(CellIDtrack{j,1},CellIDtrack{j,2},CellIDtrack{j,3},0);
    if mod(j,24) == 1
        figure;
        set(gcf,'Position',[0 0 1200 750]);
    end
    subplot(4,6,mod(j-1,24)+1); hold on; axis image;
    plot(trackf(:,1),trackf(:,2),'k.','MarkerSize',2);
    plot(trackf1(:,1),trackf1(:,2),'r.','MarkerSize',2);
    p = fitcirculartrack(trackpos1,p_guess,0);
    plot(p(3)*cos(t)+p(1),p(3)*sin(t)+p(2),'b-');
    title([CellIDarena{j,1}(1:5),';c=[',num2str(round(p(1))),',',num2str(round(p(2))),']; r=',num2str(round(p(3)))]);
    if mod(j,24) == 0
        disp(j);
        saveas(gcf,[figpath,'traj_overlaid',num2str(j/24),'.png']);
    end
end 
saveas(gcf,[figpath,'traj_overlaid3.png']);