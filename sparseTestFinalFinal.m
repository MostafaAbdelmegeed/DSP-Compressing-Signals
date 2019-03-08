ecgSignal = xlsread('C:\Users\manog\Documents\GitHub\SignalViewer-GUI\ECG Signal.csv');
discreteCosineTransform = dct(ecgSignal);

threshold = 0;
counter = 0;
found = 1;
zeroValue = 0;

for i=1:size(discreteCosineTransform)
    if discreteCosineTransform(i) > threshold
        counter = counter + 1;
    end
end

compressedSignal = zeros(counter,2);
for j=1:counter
    if discreteCosineTransform(j) > threshold
        compressedSignal(found,1) = j;
        compressedSignal(found,2) = discreteCosineTransform(j);
        found = found + 1;
    end
end
for k=1:size(compressedSignal)
    if compressedSignal(k,1) == 0
        zeroValue = k;
        break;
    end
end
finalCompressedSignal = (compressedSignal(1:zeroValue,:));
whos;