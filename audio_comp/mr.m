% aStruct = load('sampleData.mat');
% s=aStruct.spec.timeAxis;
% ppm=aStruct.spec.ppmAxis;
% freq=aStruct.spec.freqAxis;
% load('data.mat');
% csvwrite('data.csv', FileData);
exampleObject = matfile('data.mat');
first = exampleObject.data(:,1:1000);
% S = whos('-file','data.mat');
% for k = 1:length(S)
%    disp(['  ' S(k).name ...
%          '  ' mat2str(S(k).size) ...
%          '  ' S(k).class]);
% end
whos -file data.mat;
out=reshape(first,[],1);
out1=abs(out);
t=0:68000:1;
plot(t,out1);
figure
[cA,cD] = dwt(out,'haar');
t11=0:3400:1;
c=abs(cA);
plot(t11,c);
figure


