function [  ] = exnoise2_plot(  )
%EXNOISE2_PLOT Summary of this function goes here
%   Detailed explanation goes here
load('exnoise2.mat','exnoise2');
wid = 3;

sw = zeros(numel(exnoise2)-wid+1,3);
for i=1:numel(exnoise2)-wid+1
    sw(i,:) = exnoise2(i:i+wid-1);
end

scatter(sw(:,1),sw(:,2));
hold on;
scatter(sw(30:36,1),sw(30:36,2),36,'r','MarkerFaceColor','r');
scatter(sw(63:69,1),sw(63:69,2),36,'g','MarkerFaceColor','g');
hold off;
text(sw(33,1),sw(33,2),'A','horizontal','left', 'vertical','bottom','FontSize',16,'fontWeight','bold');
text(sw(66,1),sw(66,2),'B','horizontal','left', 'vertical','bottom','FontSize',16,'fontWeight','bold');
text(sw(20,1),sw(20,2),'C','horizontal','left', 'vertical','bottom','FontSize',16,'fontWeight','bold');

end

