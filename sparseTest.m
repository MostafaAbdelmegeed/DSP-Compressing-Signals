% testing Emmanuel's Algorithm using signal

clear all;
ecgSignal = xlsread('ECG Signal.csv');
discreteCosineTransform = dct(ecgSignal);

threshold1 = .005;
threshold2 = -.005;

counter = 0;
dlmwrite ('original_file.txt',ecgSignal,'delimiter', ' ','newline','pc');
x= length (ecgSignal);

for i=1:size(discreteCosineTransform)
    if discreteCosineTransform(i)>threshold1
       
        counter = counter + 1;
    
    end
end

for i=1:size(discreteCosineTransform)
    if discreteCosineTransform(i) <threshold2
       
        counter = counter + 1;
    
    end
end

compressedSignal = zeros(counter,2);
for i=1:counter
    if discreteCosineTransform(i)>threshold1
        if discreteCosineTransform(i)<threshold2
        compressedSignal(i,1) = i;
        compressedSignal(i,2) = discreteCosineTransform(i);
        end
    end
end
 
 dlmwrite('mydata.txt',compressedSignal ,'delimiter', ' ','newline','pc');
[filename,filepath] = uigetfile('*.txt','Select a Signal');
 file = [filepath filename];
 back_file = dlmread(filename,' ');
 
 
 
 [i,j,v] = find(back_file) ;recovery_signal=zeros(x,1);
 recovery_signal(i,1)= v (i);
 
recoveredSignal=idct(recovery_signal);
plot(ecgSignal )
figure
plot(recoveredSignal)

 
whos;