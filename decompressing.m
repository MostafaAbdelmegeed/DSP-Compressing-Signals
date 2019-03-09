[filename,filepath] = uigetfile('*.mat','Select a Signal');
file = [filepath filename];
compressed_file = matfile(file);

sparsed_signal=compressed_file.sparsed_transformed_signal;

full_signal=full(sparsed_signal);

retrievedSignal=idwt(full_signal(:,1),full_signal(:,2),'haar');

xlswrite('decompressed.xlsx',retrievedSignal);