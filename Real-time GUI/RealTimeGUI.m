function varargout = RealTimeGUI(varargin)
% REALTIMEGUI MATLAB code for RealTimeGUI.fig
%      REALTIMEGUI, by itself, creates a new REALTIMEGUI or raises the existing
%      singleton*.
%
%      H = REALTIMEGUI returns the handle to a new REALTIMEGUI or the handle to
%      the existing singleton*.
%
%      REALTIMEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REALTIMEGUI.M with the given input arguments.
%
%      REALTIMEGUI('Property','Value',...) creates a new REALTIMEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RealTimeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RealTimeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RealTimeGUI

% Last Modified by GUIDE v2.5 26-May-2021 19:06:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RealTimeGUI_OpeningFcn, ...
    'gui_OutputFcn',  @RealTimeGUI_OutputFcn, ...
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


% --- Executes just before RealTimeGUI is made visible.
function RealTimeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RealTimeGUI (see VARARGIN)

% Choose default command line output for RealTimeGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RealTimeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RealTimeGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadsignal.
function loadsignal_Callback(hObject, eventdata, handles)
% hObject    handle to loadsignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global signal models hh

Time = clock;
Date = round([Time(3) Time(2) Time(1)]);
PID = "XXX-001";
set(handles.P_ID,'String',PID);
set(handles.C_no,'String',"0001");
set(handles.d_date,'String',num2str(Date));



%load models
d1=load('net1mat');
d2=load('net2.mat');
d3=load('net3.mat');
model1 =d1.net1;
model2 = d2.net2;
model3 = d3.net3;
models = [model1,model2,model3];

cd('E:\PROJECTS\ECG analysis\Test signals')

[filename, ~]=uigetfile('*.*');
signal = load(filename);
cd('E:\PROJECTS\ECG analysis')
n1= signal.val;
hh=heartrate(n1);

if hh<60
    condition = "Bradycardia";
elseif hh>100
    condition = "Tachycardia";
else
    condition = "Normal Heart Rate";
end

param = RRfeaturevec(n1);
param1 = param(2);
param2 = param(5);

y=n1;
j=1;
n=length(y);
for i=2:n-1
    if y(i)> y(i-1) && y(i)>= y(i+1) && y(i)> 0.45*max(y)
       val(j)= y(i);
       pos(j)=i;
       j=j+1;
     end
end
ecg_peaks=j-1;
ecg_pos=pos./1000;
j=1;
for i=1:ecg_peaks-1
    e(j)= ecg_pos(i+1)-ecg_pos(i);% gives RR interval
    j=j+1;
    
end 
hr=60./mean(e); % 60/ mean of RR interval


% heartrate(ecg)
set(handles.hrtrate,'String',hh);
set(handles.hrv,'String',num2str(hr));

set(handles.condition,'String',condition);
set(handles.avrr,'String',num2str(param1));
set(handles.nn50,'String',num2str(param2));




%
k=1;
r=1500;
m=6;
w=3;


for i=1:m
    
    aa(:,i)=n1(k:k+r-1);    
    k=k+r;

    %Rpeak amplitudes
    [~, PkTime] = findpeaks(aa(:,i), 'MinPeakHeight', 100);
    Actual_Time = PkTime/length(aa(:,i));    
    Actual_Time(i,:)=Actual_Time(1,:);    
    Actual_Time=Actual_Time';
    set(handles.rpeakval,'String',Actual_Time);
    
    
        b=i-w+1:i;
        b=b(b>0);
        
        tt=aa(:,b);
        tt=tt(:);
        [qrs_amp_raw,qrs_i_raw,ecg_h]=pan_tompkin(tt,250,1);
        
        
        %ECG plot
        g=[];
        if ishandle(g)
            set(g,'XData',1:length(tt),'YData',tt);            
            
        else
                        
            g = plot(handles.axes1,tt);            
            set(handles.axes1,'xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[]);
            xlabel(handles.axes1,'Samples')
            ylabel(handles.axes1,'Amplitude ( mV )')            
            set(g,'XData',1:length(tt),'YData',tt);            
        end
        
        %rpeak plot
        h=[];
        if ishandle(h)
            set(h,'XData',1:length(ecg_h),'YData',ecg_h)           
            
        else
            h = plot(handles.axes3,ecg_h);
        end
        axis tight;
        set(gca,'xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[]);
        xlabel(handles.axes3,'Samples')        
        hold on,
        scatter(handles.axes3,qrs_i_raw,qrs_amp_raw,'m');
        drawnow
        axis([0 5000 -2 2])
        pause(1)
        hold off
        
set(handles.rpeakval,'String',Actual_Time);
end








% --- Executes on button press in filtersignal.
function filtersignal_Callback(hObject, eventdata, handles)
% hObject    handle to filtersignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in filtersigdisp.
function filtersigdisp_Callback(hObject, eventdata, handles)
% hObject    handle to filtersigdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in analyse.
function analyse_Callback(hObject, eventdata, handles)
% hObject    handle to analyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global signal models hh

test = testfeatureextract(signal);

tstart=tic;
for j = 1:numel(models)    
    pred(:,j)=classify(models(j),test(1,j));
    %     scores(:,j)=sum(pred(:,j) == YTest)/numel(YTest)*100;
end
%     scores(:,j)=sum(pred == YTest)/numel(YTest)*100;


result = [0,0,0];

for i=1:length(pred)
    if pred(i) == 'N'
        result(i) = 0;
    elseif pred(i) == 'A'
        result(i) = 1;
    elseif pred(i) == 'O'
        result(i) = 2;
    end
end

if numel(unique(result)) == 1 
    avg_pred = mean(result);
elseif numel(unique(result)) == 2
    avg_pred = mode(result);
else
    avg_pred = round(mean(result));
end


if avg_pred == 0
    condition = "Normal";
elseif avg_pred == 1
    condition = "Atrial Fibrillation Detected";
elseif avg_pred == 2
    condition = "Other Arrhythmia Detected";
end

set(handles.resultdisp,'String',condition);
tend=toc(tstart);
set(handles.detecttime,'String',num2str(tend));

if avg_pred == 0 && hh>60 && hh<100
    prog = "No problem detected";
elseif avg_pred == 1 && hh<60
    prog = "Consult doctor ASAP";
elseif avg_pred == 2 && hh<60
    prog = "Consult doctor ASAP";
elseif avg_pred == 2 && hh>60
    prog = "Doctor review needed";
elseif avg_pred == 1 && hh>60
    prog = "Doctor review needed";
else
    prog = "No problem detected";
end
set(handles.progno,'String',prog);



function P_ID_Callback(hObject, eventdata, handles)
% hObject    handle to P_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_ID as text
%        str2double(get(hObject,'String')) returns contents of P_ID as a double


% --- Executes during object creation, after setting all properties.
function P_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C_no_Callback(hObject, eventdata, handles)
% hObject    handle to C_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C_no as text
%        str2double(get(hObject,'String')) returns contents of C_no as a double


% --- Executes during object creation, after setting all properties.
function C_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d_date_Callback(hObject, eventdata, handles)
% hObject    handle to d_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d_date as text
%        str2double(get(hObject,'String')) returns contents of d_date as a double


% --- Executes during object creation, after setting all properties.
function d_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hrtrate_Callback(hObject, eventdata, handles)
% hObject    handle to hrtrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hrtrate as text
%        str2double(get(hObject,'String')) returns contents of hrtrate as a double


% --- Executes during object creation, after setting all properties.
function hrtrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hrtrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nn50_Callback(hObject, eventdata, handles)
% hObject    handle to nn50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nn50 as text
%        str2double(get(hObject,'String')) returns contents of nn50 as a double


% --- Executes during object creation, after setting all properties.
function nn50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nn50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avrr_Callback(hObject, eventdata, handles)
% hObject    handle to avrr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avrr as text
%        str2double(get(hObject,'String')) returns contents of avrr as a double


% --- Executes during object creation, after setting all properties.
function avrr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avrr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rpeakval_Callback(hObject, eventdata, handles)
% hObject    handle to rpeakval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpeakval as text
%        str2double(get(hObject,'String')) returns contents of rpeakval as a double


% --- Executes during object creation, after setting all properties.
function rpeakval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpeakval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hrv_Callback(hObject, eventdata, handles)
% hObject    handle to hrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hrv as text
%        str2double(get(hObject,'String')) returns contents of hrv as a double


% --- Executes during object creation, after setting all properties.
function hrv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resultdisp_Callback(hObject, eventdata, handles)
% hObject    handle to resultdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resultdisp as text
%        str2double(get(hObject,'String')) returns contents of resultdisp as a double


% --- Executes during object creation, after setting all properties.
function resultdisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function progno_Callback(hObject, eventdata, handles)
% hObject    handle to progno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of progno as text
%        str2double(get(hObject,'String')) returns contents of progno as a double


% --- Executes during object creation, after setting all properties.
function progno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function condition_Callback(hObject, eventdata, handles)
% hObject    handle to condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of condition as text
%        str2double(get(hObject,'String')) returns contents of condition as a double


% --- Executes during object creation, after setting all properties.
function condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function detecttime_Callback(hObject, eventdata, handles)
% hObject    handle to detecttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detecttime as text
%        str2double(get(hObject,'String')) returns contents of detecttime as a double


% --- Executes during object creation, after setting all properties.
function detecttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detecttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
