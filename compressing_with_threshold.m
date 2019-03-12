[filename,filepath] = uigetfile('*.csv;*.xls;*.xlsv;*.xlsx','Select a Signal');

file = [filepath filename];
signal= xlsread(file);

% transformation
[approximated_signal,details_signal]=dwt(signal,'haar');

% calculating some compression parameters
[threshold,sorh,keepapp]=ddencmp('cmp','wv',details_signal);

% Looping to zerofy all the values in my threshold range
iterator=1;
while(iterator<size(details_signal,1))
    if details_signal(iterator,1) > -1*threshold && details_signal(iterator,1) < threshold
        details_signal(iterator,1)=0;
    end
      iterator=iterator+1;
end
% Sparse to squeeze zeros out
sparsed_approximated_signal=sparse(approximated_signal);
sparsed_details_signal=sparse(details_signal);
sparsed_transformed_signal=[sparsed_approximated_signal sparsed_details_signal];
% Save the file squeezed out of zeros
save('compressed.mat','sparsed_transformed_signal');