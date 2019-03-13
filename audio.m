[Audio_signal,fs]=audioread(handles.filename);
 dt = 1/fs;
 t = 0:dt:(length(Audio_signal)*dt)-dt;
 plot(t,Audio_signal);
 figure
 [cA,cD] = dwt(Audio_signal,'db8');
 x=(length(Audio_signal)/2)+7;
 t1 = 0:dt:(x*dt)-dt; 
 plot(t1,cA);
  figure 
  plot(t1,cD);
figure
z= idwt(cA,cD,'db8');
plot(t,z);
figure

 %X = dct(y);
% [XX,ind] = sort(abs(X),'descend');
% plot(t,XX);
% figure
% plot(t,ind);
% figure 
% plot(t,X);
% figure
% z=idct(X);
% plot(t,z);

