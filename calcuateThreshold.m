function threshold=calcuateThreshold(signal_matrix)
% signal segmentation
signal_1=signal_matrix(1:size(signal_matrix,2)/8);
signal_2=signal_matrix(size(signal_matrix,2)/8+1:2*size(signal_matrix,2)/8);
signal_3=signal_matrix(2*size(signal_matrix,2)/8+1:3*size(signal_matrix,2)/8);
signal_4=signal_matrix(3*size(signal_matrix,2)/8+1:4*size(signal_matrix,2)/8);
signal_5=signal_matrix(4*size(signal_matrix,2)/8+1:5*size(signal_matrix,2)/8);
signal_6=signal_matrix(5*size(signal_matrix,2)/8+1:6*size(signal_matrix,2)/8);
signal_7=signal_matrix(6*size(signal_matrix,2)/8+1:7*size(signal_matrix,2)/8);
signal_8=signal_matrix(7*size(signal_matrix,2)/8+1:8*size(signal_matrix,2)/8);
% calculating minimums
minimums=[min(signal_1) min(signal_2)  min(signal_3) min(signal_4) min(signal_5) min(signal_6) min(signal_7) min(signal_8)];
threshold = mean(minimums);
end