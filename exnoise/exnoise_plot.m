function []=exnoise_plot()
% position = [387, 512, 635, 356, 85; 746, 55, 383, 507, 774];
% wid = 20;

%EXNOISE_PLOT Summary of this function goes here
%   Detailed explanation goes here

load('exnoise.mat','exnoise');
load('exnoise_atr.mat','exnoise_atr');
load('exnoise_mydc.mat','exnoise_mydc');
load('exnoise_ordc.mat','exnoise_ordc');

% prepare color
clsp = linspace(0,1,numel(exnoise_mydc));
rdlt = [fliplr(clsp)',clsp',zeros(numel(exnoise_mydc),1)];

wid = 20;

figure;

subplot(3,1,1);
plot(exnoise,'b');
title('Original time series');
hold on;
for i=exnoise_atr
plot(i:i+wid-1,exnoise(i:i+wid-1),'r','LineWidth',3);
end
hold off;

subplot(3,1,2);
plot(exnoise,'b');
title('Top K discord');
hold on;
for i=1:numel(exnoise_ordc)
    orig = exnoise_ordc(i);
    plot(orig:orig+wid-1,exnoise(orig:orig+wid-1),'Color',rdlt(i,:),'LineWidth',3);
end
hold off;

subplot(3,1,3);
plot(exnoise,'b');
title('Top K J-ZNDistance discords');
hold on;
for i=1:numel(exnoise_mydc)
    my = exnoise_mydc(i);
    plot(my:my+wid-1,exnoise(my:my+wid-1),'Color',rdlt(i,:),'LineWidth',3);
end
hold off;

end