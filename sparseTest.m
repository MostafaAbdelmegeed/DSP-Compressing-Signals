clear all;
ecgSignal = xlsread('ECG Signal.csv');
discreteCosineTransform = dct(ecgSignal);

threshold = 0;
counter = 0;
dlmwrite ('original_file.txt',ecgSignal,'delimiter', ' ','newline','pc');
x= length (ecgSignal);

for i=1:size(discreteCosineTransform)
    if discreteCosineTransform(i)>threshold
        counter = counter + 1;
    end
end

compressedSignal = zeros(counter,2);
for i=1:counter
    if discreteCosineTransform(i)>threshold
        compressedSignal(i,1) = i;
        compressedSignal(i,2) = discreteCosineTransform(i);
    end
end
 
 dlmwrite('mydata.txt',compressedSignal ,'delimiter', ' ','newline','pc');
[filename,filepath] = uigetfile('*.txt','Select a Signal');
 file = [filepath filename];
 back_file = dlmread(filename,' ');
 
 
 
 [i,j,v] = find(back_file) ;
 recovery_signal=zeros(x,1);
 recovery_signal(i,1)= v (i);
 
recoveredSignal=idct(recovery_signal);
plot(ecgSignal )
figure
plot(recoveredSignal)

 
whos;