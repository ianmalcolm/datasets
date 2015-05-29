function [] = sel102s300_400_plot()
load('sel102s300_400.mat','sel102s300_400');
load('sel102s300_400_atr.mat','sel102s300_400_atr');
load('sel102s300_400_mydc.mat','sel102s300_400_mydc');
load('sel102s300_400_ordc.mat','sel102s300_400_ordc');
freq = 360;
tstart = 300;
tend = (size(sel102s300_400(:,1),1)-1)/freq+tstart;
time = linspace(tstart,tend,size(sel102s300_400(:,1),1));

wid=180;

clsp = linspace(0,1,numel(sel102s300_400_mydc));
rdlt = [fliplr(clsp)',clsp',zeros(numel(sel102s300_400_mydc),1)];

figure;
subplot(3,1,1);
plot(time,sel102s300_400(:,1),'b');
xlabel('Time / s'); ylabel('Voltage / mV');
title('ECG time series extracted from 102.dat in MIT-BIH Arrhythmia Database');
hold on;
for i=sel102s300_400_atr(:,1)'
    assert((i-freq/2)>freq/2);
    assert((i+freq/2)<size(sel102s300_400(:,1),1)-freq/2);
    plot(time(i-freq/2:i+freq/2),sel102s300_400(i-freq/2:i+freq/2,1),'r');
end
hold off;

subplot(3,1,2);
plot(time,sel102s300_400(:,1),'b');
xlabel('Time / s'); ylabel('Voltage / mV');
title('Top K discord');
hold on;
for i=1:numel(sel102s300_400_mydc)
    orig = sel102s300_400_ordc(i);
    plot(time(orig:orig+wid-1),sel102s300_400(orig:orig+wid-1),'Color',rdlt(i,:),'LineWidth',3);
end
hold off;

subplot(3,1,3);
plot(time,sel102s300_400(:,1),'b');
xlabel('Time / s'); ylabel('Voltage / mV');
title('Top K J-ZNDistance discords');
hold on;
for i=1:numel(sel102s300_400_mydc)
    my = sel102s300_400_mydc(i);
    plot(time(my:my+wid-1),sel102s300_400(my:my+wid-1),'Color',rdlt(i,:),'LineWidth',3);
end
hold off;

end
