% compress button
%input to be used (details signal and approx. signal)
% calculating some compression parameters
% cmp for compression , wv to use wavelets
[threshold,sorh,keepapp]=ddencmp('cmp','wv',details_signal);
%Threshold for denoising or compression, returned as a real number

%in case of choosing lossy
% Looping to zerofy all the values in my threshold range
iterator=1;
% setting threshold to lose the insignificant imformation
while(iterator<size(details_signal,1))
    if details_signal(iterator,1) > -1*threshold && details_signal(iterator,1) < threshold
        details_signal(iterator,1)=0;
    end
      iterator=iterator+1;
end

% in case of choosing losless
iterator=1;
% setting threshold to lose the insignificant imformation
while(iterator<size(details_signal,1))
    if details_signal(iterator,1) > -1*(threshold/100) && details_signal(iterator,1) < (threshold/100)
        details_signal(iterator,1)=0;
    end
      iterator=iterator+1;
end

% Sparse to squeeze zeros out
sparsed_approximated_signal=sparse(approximated_signal);
sparsed_details_signal=sparse(details_signal);
sparsed_transformed_signal=[sparsed_approximated_signal sparsed_details_signal];
save ('Compressed_Signal.mat', 'sparsed_transformed_signal');

%open compressed signal button
back_file = load('Compressed_Signal.mat');
%recovery of the array & access of the struct elements
recovery_signal=full(back_file.sparsed_transformed_signal);