orig=importdata('xmitdb_orig.txt');
mdf=importdata('xmitdb_mdf.txt');
figure;
subplot(2,1,1);
plot(orig(:,2));title('Original ECG data');
subplot(2,1,2);
plot(mdf(:,2));title('Modified ECG data');

orig_hotsax=[3844,1748,3444,3017,4300];
orig_brute=[4083,1749,4667,443,2888];
orig_brutez=[4095,1790,1158,3576,4978];
mdf_hotsax=[3012,2363,1464,3577,751];
mdf_brute=[2710,4099,1749,2350,4667];
% mdf_brutez=[2442,3846,2803,4978,1782];
mdf_brutez=[2707,4083,1812,4666,442];

width=360;

figure;
subplot(3,1,1);
plot(orig(:,2));
subplot(3,1,2);
plot(orig(:,2));
subplot(3,1,3);
plot(orig(:,2));

for i=orig_hotsax
    subplot(3,1,1);
    hold on;plot(i:i+359,orig(i:i+359,2),'r.');hold off;
    title('Original ECG data: Discover discord using Hot SAX');
end
for i=orig_brute
    subplot(3,1,2);
    hold on;plot(i:i+359,orig(i:i+359,2),'r.');hold off;
    title('Original ECG data: Discover discord using Brute Force method');
end
for i=orig_brutez
    subplot(3,1,3);
    hold on;plot(i:i+359,orig(i:i+359,2),'r.');hold off;
    title('Original ECG data: Discover discord using Z-normalization and Brute Force method');
end

figure;
subplot(3,1,1);
plot(mdf(:,2));
subplot(3,1,2);
plot(mdf(:,2));
subplot(3,1,3);
plot(mdf(:,2));

for i=mdf_hotsax
    subplot(3,1,1);
    hold on;plot(i:i+359,mdf(i:i+359,2),'r.');hold off;
    title('Modified ECG data: Discover discord using Hot SAX');
end
for i=mdf_brute
    subplot(3,1,2);
    hold on;plot(i:i+359,mdf(i:i+359,2),'r.');hold off;
    title('Modified ECG data: Discover discord using Brute Force method');
end
for i=mdf_brutez
    subplot(3,1,3);
    hold on;plot(i:i+359,mdf(i:i+359,2),'r.');hold off;
    title('Modified ECG data: Discover discord using Z-normalization and Brute Force method');
end