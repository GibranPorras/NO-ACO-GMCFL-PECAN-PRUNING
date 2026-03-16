function varargout = gui_datacursormode(varargin)
% GUI_DATACURSORMODE MATLAB code for gui_datacursormode.fig
%      GUI_DATACURSORMODE, by itself, creates a new GUI_DATACURSORMODE or raises the existing
%      singleton*.
%
%      H = GUI_DATACURSORMODE returns the handle to a new GUI_DATACURSORMODE or the handle to
%      the existing singleton*.
%
%      GUI_DATACURSORMODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DATACURSORMODE.M with the given input arguments.
%
%      GUI_DATACURSORMODE('Property','Value',...) creates a new GUI_DATACURSORMODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_datacursormode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_datacursormode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_datacursormode

% Last Modified by GUIDE v2.5 02-Apr-2017 17:45:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_datacursormode_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_datacursormode_OutputFcn, ...
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


% --- Executes just before gui_datacursormode is made visible.
function gui_datacursormode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_datacursormode (see VARARGIN)

% Choose default command line output for gui_datacursormode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_datacursormode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_datacursormode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_2d.
function pushbutton_2d_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot two lines in the first axes
t=0:.1:2*pi;
plot(handles.axes_2d,t,sin(t),'r');
hold(handles.axes_2d,'on')
plot(handles.axes_2d,t,cos(t),'b');
% Enable the checkbox that will set datacorsormode on
handles.checkbox_enable_dc.Enable='on';


% --- Executes on button press in pushbutton_3d.
function pushbutton_3d_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot a 3D graph in the second axes
axes(handles.axes_3d);
peaks

% Enable the checkbox that will set datacorsormode on
handles.checkbox_enable_dc.Enable='on';


function txt = myupdatefcn(~,event_obj,t)
% Customizes text of data tips

% Get the handles of the GUI to access to the radiobuttons
my_guidata=guidata(gcf);
% Define the additional string to be written
if(my_guidata.radiobutton1.Value)
   str='DEFAULT STRING ';
elseif(my_guidata.radiobutton2.Value)
   str='STRING OPTION ONE ';
else
   str='STRING OPTION TWO ';
end

% Get the datacursor data
pos = get(event_obj,'Position');
I = get(event_obj, 'DataIndex');
% Create the whole string to be written
txt = {[str], ...
       ['X: ',num2str(pos(1))],...
       ['Y: ',num2str(pos(2))],...
       ['I: ',num2str(I)],...
       ['T: ',num2str(t(I))]}


% --- Executes on button press in checkbox_enable_dc.
function checkbox_enable_dc_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_enable_dc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If the checkbox is set
if(hObject.Value)
   %  enable the radiobuttons that control the string to be written
   handles.radiobutton1.Enable='on';
   handles.radiobutton1.Value=1;
   handles.radiobutton2.Enable='on';
   handles.radiobutton3.Enable='on';
   % Create the datacursormode object
   dcm_obj = datacursormode(gcf)
   t=rand(1,10000);
   set(dcm_obj,'DisplayStyle','datatip',...
      'SnapToDataVertex','off','Enable','on', ...
      'UpdateFcn',{@myupdatefcn,t})
else
   % If the checkbox is not set, disable the datacursormode
   datacursormode 'off'
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% Toggle the other radiobuttons
handles.radiobutton2.Value=0
handles.radiobutton3.Value=0

% --- Executes on button press in radiobutton1.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% Toggle the other radiobuttons
handles.radiobutton1.Value=0
handles.radiobutton3.Value=0


% --- Executes on button press in radiobutton1.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% Toggle the other radiobuttons
handles.radiobutton1.Value=0
handles.radiobutton2.Value=0