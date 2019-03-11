
% testing Emmanuel's Algorithm using array
clear all;

% [filename,filepath] = uigetfile('*.csv;*.xls;*.xlsv','Select a Signal');
% file = [filepath filename];
% signal= xlsread(file,'A3:A1000');
% signal= transpose(signal);
% 
% discreteCosineTransform=dct(signal);
% 
% 
% discreteCosineTransform((discreteCosineTransform > -.0001) &(discreteCosineTransform < .0001) )=0;
% %discreteCosineTransform(discreteCosineTransform < .0001 )=0;
% discreteCosineTransform= transpose(discreteCosineTransform);


A = [1,2,3,5,6,7,7,8,9,10,0,11,12,0,14,15,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,11,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,45,5,5,5,55,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,77,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,5];
A = transpose (A);
threshold =0;
counter =0;
x= length (A);

for i=1:size(A)
    if A(i)>threshold
        counter = counter + 1;  
    end
end
compressedSignal = zeros(counter,2);
for i=1:counter
    if A(i)>threshold
      
        compressedSignal(i,1) = i;
        compressedSignal(i,2) = A(i);
        
    end
end
 dlmwrite('mydata.txt',compressedSignal ,'delimiter', ' ','newline','pc');
[filename,filepath] = uigetfile('*.txt','Select a Signal');
 file = [filepath filename];
 back_file = dlmread(filename,' ');
 
 
 
 [i,j,v] = find(back_file) ;recovery_signal=zeros(x,1);
 recovery_signal(i,1)= v (i);
 
recoveredSignal=idct(recovery_signal);
plot(A )
figure
plot(recoveredSignal)

 
whos;



