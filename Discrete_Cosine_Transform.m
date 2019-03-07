[filename,filepath] = uigetfile('*.csv;*.xls;*.xlsv','Select a Signal');
file = [filepath filename];
signal= xlsread(file,'A3:A1000');
signal= transpose(signal);

discreteCosineTransform=dct(signal);

compression_factor=4;


% Removing all the high frequencies and taking only the first quarter of
% the spectrum (Low frequencies)
discreteCosineTransform(size(discreteCosineTransform,2)/compression_factor:size(discreteCosineTransform,2))=zeros;


%iterator=1;
% while(iterator<size(discreteCosineTransform,2))
%     if discreteCosineTransform(1,iterator) > -0.001 && discreteCosineTransform(1,iterator) < 0.001
%         preceding=discreteCosineTransform(1,1:iterator-1);
%         ahead=discreteCosineTransform(1,iterator+1:size(discreteCosineTransform,2));
%         discreteCosineTransform=[preceding ahead];
%         if iterator~=1
%         iterator=iterator-1;
%         end
%     end
%     iterator=iterator+1;
% end

recoveredSignal=idct(discreteCosineTransform);
plot(signal)
hold on
plot(recoveredSignal)

