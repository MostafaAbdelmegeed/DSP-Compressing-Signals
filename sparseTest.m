ecgSignal = xlsread('C:\Users\manog\Documents\GitHub\SignalViewer-GUI\ECG Signal.csv');
discreteCosineTransform = dct(ecgSignal);

threshold = 0;
counter = 0;

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
whos;