function varargout = dsp_signal_compression(varargin)
% DSP_SIGNAL_COMPRESSION MATLAB code for dsp_signal_compression.fig
%      DSP_SIGNAL_COMPRESSION, by itself, creates a new DSP_SIGNAL_COMPRESSION or raises the existing
%      singleton*.
%
%      H = DSP_SIGNAL_COMPRESSION returns the handle to a new DSP_SIGNAL_COMPRESSION or the handle to
%      the existing singleton*.
%
%      DSP_SIGNAL_COMPRESSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSP_SIGNAL_COMPRESSION.M with the given input arguments.
%
%      DSP_SIGNAL_COMPRESSION('Property','Value',...) creates a new DSP_SIGNAL_COMPRESSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dsp_signal_compression_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dsp_signal_compression_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dsp_signal_compression

% Last Modified by GUIDE v2.5 11-Mar-2019 23:48:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dsp_signal_compression_OpeningFcn, ...
                   'gui_OutputFcn',  @dsp_signal_compression_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dsp_signal_compression is made visible.
function dsp_signal_compression_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dsp_signal_compression (see VARARGIN)

% Choose default command line output for dsp_signal_compression
handles.output = hObject;

handles.mode='Lossy';
handles.basis='haar';
handles.compressed_filename='compressed.mat';
handles.MATFLAG=false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dsp_signal_compression wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dsp_signal_compression_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.filename,handles.filepath] = uigetfile('*.csv;*.xls;*.xlsv;*.xlsx;*.mat','Select a Signal');
handles.file = [handles.filepath handles.filename];
if handles.file
    set(handles.compress_button,'Enable','off');
    set(handles.decompress_button,'Enable','off');
    [path,name,ext]=fileparts(handles.file);
    directory=dir(handles.file);
    handles.filesize=directory.bytes;
    if strcmp('.mat',ext)
        handles.MATFLAG=true;
        file = matfile(handles.file);
        handles.signal=file.ult_sig(1:length(file.ult_sig),1);
        set(handles.compress_button,'Enable','on');
    else
        handles.signal= xlsread(handles.file);
        set(handles.compress_button,'Enable','on');
    end
end

% Plotting
axes(handles.original_axis);
cla;
plot(handles.signal(1:1000,1))
hold on
title(handles.filename);

guidata(hObject,handles);


% --- Executes on selection change in mode_menu.
function mode_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mode_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'))
handles.mode=contents{get(hObject,'Value')};
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns mode_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mode_menu


% --- Executes during object creation, after setting all properties.
function mode_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mode_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compress_button.
function compress_button_Callback(hObject, eventdata, handles)
% hObject    handle to compress_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~strcmp(handles.basis,'dct')&& ~strcmp(handles.basis,'wht')
% Discrete wavelet transformation 
[approximated_signal,details_signal]=dwt(handles.signal,handles.basis);
else if strcmp(handles.basis,'dct')
        % Discrete Cosine transformation
    transformed_signal=dct(handles.signal);
    approximated_signal=transformed_signal(1:floor((length(transformed_signal)/2)),1);
    details_signal=transformed_signal(floor((length(transformed_signal)/2))+1:length(transformed_signal),1);
    end
else if strcmp(handles.basis,'wht')
        % Walsh Hadamard Transform
        transformed_signal=fwht(handles.signal);
        approximated_signal=transformed_signal(1:floor((length(transformed_signal)/2)),1);
        details_signal=transformed_signal(floor((length(transformed_signal)/2))+1:length(transformed_signal),1);
    end
end

% calculating threshold
[threshold,sorh,keepapp]=ddencmp('cmp','wv',details_signal);


if strcmp(handles.mode,'Lossy');
    % in case of choosing lossy
% Looping to zerofy all the values in my threshold range
iterator=1;
while(iterator<size(details_signal,1))
    if details_signal(iterator,1) > -1*threshold && details_signal(iterator,1) < threshold
        details_signal(iterator,1)=0;
    end
      iterator=iterator+1;
end
set(handles.edit2,'String',threshold);

else if strcmp(handles.mode,'Lossless')
    % in case of choosing lossless
iterator=1;
% setting threshold to lose the insignificant imformation
while(iterator<size(details_signal,1))
    if details_signal(iterator,1) > -1*(threshold/100) && details_signal(iterator,1) < (threshold/100)
        details_signal(iterator,1)=0;
    end
      iterator=iterator+1;
end
set(handles.edit2,'String',threshold/100);
    end
end
    
% Sparse to squeeze zeros out
sparsed_approximated_signal=sparse(approximated_signal);
sparsed_details_signal=sparse(details_signal);
sparsed_transformed_signal=[sparsed_approximated_signal sparsed_details_signal];
% Save the file squeezed out of zeros
save(handles.compressed_filename,'sparsed_transformed_signal');

% Calculating compression factor
compressed_file=dir(handles.compressed_filename);
handles.compressed_file_size= compressed_file.bytes;
compression_ratio=handles.filesize/handles.compressed_file_size;

% Plotting
axes(handles.original_axis);
cla;
plot(handles.signal(1:1000,1))
hold on
title(handles.filename);

% Some GUI tweaks
set(handles.edit1,'String',compression_ratio);
set(handles.decompress_button,'Enable','on');
set(handles.indicator_text,'String','File compressed successfully!');

% Updating GUI
guidata(hObject,handles);


% --- Executes on button press in decompress_button.
function decompress_button_Callback(hObject, eventdata, handles)
% hObject    handle to decompress_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reading compressed matrix
compressed_file = matfile(handles.compressed_filename);
full_signal=full(compressed_file.sparsed_transformed_signal);

% Executing decompression according to basis selected
% If not dct or wht, then inverse dwt
if ~strcmp(handles.basis,'dct')&& ~strcmp(handles.basis,'wht')
retrievedSignal=idwt(full_signal(:,1),full_signal(:,2),handles.basis);
% If dct then inverse dct
else if strcmp(handles.basis,'dct')
        signal_remerged=reshape(full_signal,[length(handles.signal),1]);
        retrievedSignal=idct(signal_remerged);
    end
    else if strcmp(handles.basis,'wht')
        signal_remerged=reshape(full_signal,[length(handles.signal),1]);
        retrievedSignal=ifwht(signal_remerged);
        end
end
% Deciding what is the final extension of the decompressed file according
% to the original file
if ~handles.MATFLAG
    % If not .mat, then it's an excel file
xlswrite('decompressed.xlsx',retrievedSignal);
else
    % else if .mat, retrieve it as .mat file
save('decompressed.mat','retrievedSignal');
end

% GUI Tweaks
set(handles.indicator_text,'String','File decompressed successfully!');

plot(retrievedSignal(1:1000,1));
legend('Original','Decompressed');
guidata(hObject,handles);


% --- Executes on selection change in basis_menu.
function basis_menu_Callback(hObject, eventdata, handles)
% hObject    handle to basis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'))
handles.basis=contents{get(hObject,'Value')}
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns basis_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from basis_menu



% --- Executes during object creation, after setting all properties.
function basis_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
