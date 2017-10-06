function varargout = HSV_GUI(varargin)
% HSV_GUI MATLAB code for HSV_GUI.fig
%      HSV_GUI, by itself, creates a new HSV_GUI or raises the existing
%      singleton*.
%
%      H = HSV_GUI returns the handle to a new HSV_GUI or the handle to
%      the existing singleton*.
%
%      HSV_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HSV_GUI.M with the given input arguments.
%
%      HSV_GUI('Property','Value',...) creates a new HSV_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HSV_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HSV_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HSV_GUI

% Last Modified by GUIDE v2.5 30-Sep-2017 08:56:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HSV_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @HSV_GUI_OutputFcn, ...
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


% --- Executes just before HSV_GUI is made visible.
function HSV_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HSV_GUI (see VARARGIN)

% Choose default command line output for HSV_GUI
set(handles.figure1,'Units', 'pixels');
pos = get(handles.figure1,'Position');
screenSize = get(0, 'ScreenSize');

set(handles.figure1,'Units', 'normalized');
dy_px = (screenSize(4)-pos(4))/2;
dx_px = (screenSize(3)-pos(3))/2;

y = dy_px/screenSize(4);
x = dx_px/screenSize(3);

set(handles.figure1,'Position', [x y 2*pos(3)/screenSize(3) 2*pos(4)/screenSize(4)]);

handles.output = hObject;


set(handles.tag_mainaxes,'xtick',[]);
set(handles.tag_mainaxes,'ytick',[]);
set(handles.tag_mainaxes,'box','on');

set(handles.button_play,'enable','off');
set(handles.button_plus1,'enable','off');
set(handles.button_minus1,'enable','off');
set(handles.button_rev,'enable','off');
set(handles.button_pause,'enable','off');
        
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HSV_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HSV_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_play.
function button_play_Callback(hObject, eventdata, handles)
% hObject    handle to button_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_pauseframestatus(hObject,handles);
handles.stop_now = 0;
handles.dir = 1;

guidata(hObject,handles);

update_changedirection(hObject,handles);
handles = guidata(hObject);
update_continualrun(hObject,handles);

% --- Executes on button press in button_plus1.
function button_plus1_Callback(hObject, eventdata, handles)
% hObject    handle to button_plus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_pauseframestatus(hObject,handles);
handles.stop_now = 1;
handles.dir = 1;

guidata(hObject,handles);

update_changedirection(hObject,handles);
handles = guidata(hObject);
update_singleframe(hObject,handles);

% --- Executes on button press in button_minus1.
function button_minus1_Callback(hObject, eventdata, handles)
% hObject    handle to button_minus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_pauseframestatus(hObject,handles);
handles.stop_now = 1;
handles.dir = -1;

guidata(hObject,handles);

update_changedirection(hObject,handles);
handles = guidata(hObject);
update_singleframe(hObject,handles);

% --- Executes on button press in button_pause.
function button_pause_Callback(hObject, eventdata, handles)
% hObject    handle to button_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.stop_now = 1;
guidata(hObject, handles);

% --- Executes on button press in button_rev.
function button_rev_Callback(hObject, eventdata, handles)
% hObject    handle to button_rev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_pauseframestatus(hObject,handles);
handles.stop_now = 0;
handles.dir = -1;

guidata(hObject,handles);

update_changedirection(hObject,handles);
handles = guidata(hObject);
update_continualrun(hObject,handles);

% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
% hObject    handle to button_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_load(hObject,handles);


% --- Functions
function update_load(hObject,handles)
    [fname,fpath] = uigetfile('*.mat*','Select Files for Video','MultiSelect', 'off');
    data = load(fullfile(fpath,fname));
    fls = fieldnames(data);
    data = data.(fls{1});
    frames = [1:length(data)]';
    n_frames = length(data);
    
    fld = fieldnames(data);
    fld = fld{1};
    
    cmin = min(data(1).(fld)(:));
    cmax = max(data(1).(fld)(:));
    
    axes(handles.tag_mainaxes);
    imagesc(data(1).(fld)); caxis([cmin cmax]); axis image;
    set(handles.tag_mainaxes,'xtick',[]);
    set(handles.tag_mainaxes,'ytick',[]);
    
    handles.UserData=data;
    handles.cmin = cmin;
    handles.cmax = cmax;
    handles.frames = frames;
    handles.open_status = 1;
    handles.fld = fld;
    handles.dir = 1;
    
    set(handles.caxis_min,'String',num2str(cmin));
    set(handles.caxis_max,'String',num2str(cmax));
    set(handles.text_title,'String',fname);
    set(handles.text_gotoframe,'String',['Go to Frame (' num2str(n_frames) ')']);
    
    set(handles.button_play,'enable','on');
    set(handles.button_plus1,'enable','on');
    set(handles.button_minus1,'enable','on');
    set(handles.button_rev,'enable','on');
    set(handles.button_pause,'enable','on');
    
    guidata(hObject,handles);
    
function update_pauseframestatus(hObject,handles)
    handles.stop_now = 1;
    guidata(hObject,handles);
    
function update_changedirection(hObject,handles)
    frames = handles.frames;
    if isfield(handles,'olddir')
        olddir = handles.olddir;
        dir = handles.dir;
        if olddir*dir<0
            frames = circshift(frames,[-2*dir,0]);
            handles.frames = frames;
        end
        handles.olddir = dir;
    end

guidata(hObject,handles);
    
function update_continualrun(hObject,handles)
    data = handles.UserData;
    fld = handles.fld;
    cmin = handles.cmin;
    cmax = handles.cmax;
    frames = handles.frames;
    dir = handles.dir;
    fps = get(handles.fps,'string');
    fps = str2double(fps);
    interval = 1/fps;
    
    update_grayout_buttons(hObject,handles);
    
    while ~(handles.stop_now)
        i = frames(1);
        axes(handles.tag_mainaxes);
        imagesc(data(i).(fld)); caxis([cmin cmax]); axis image; 
        set(handles.tag_mainaxes,'xtick',[]);
        set(handles.tag_mainaxes,'ytick',[]);
        drawnow;
        pause(interval);
        
        set(handles.frame_counter,'string',num2str(i));
        frames = circshift(frames,[-1*dir,0]);
        
        handles.frames = frames;
        temp_guidata = guidata(hObject);
        handles.stop_now = temp_guidata.stop_now;
        if dir == -1
            handles.olddir = -1;
        elseif dir == 1;
            handles.olddir = 1;
        end
        guidata(hObject,handles);
    end
    
    handles.frames = frames;
    update_grayout_buttons(hObject,handles)
    guidata(hObject,handles);

function update_singleframe(hObject,handles)
    data = handles.UserData;
    fld = handles.fld;
    cmin = handles.cmin;
    cmax = handles.cmax;
    frames = handles.frames;
    dir = handles.dir;
    
    i = frames(1);
    axes(handles.tag_mainaxes);
    imagesc(data(i).(fld)); caxis([cmin cmax]); axis image; 
    set(handles.tag_mainaxes,'xtick',[]);
    set(handles.tag_mainaxes,'ytick',[]);
    drawnow;


    set(handles.frame_counter,'string',num2str(i));
    frames = circshift(frames,[-1*dir,0]);

    if dir == -1
        handles.olddir = -1;
    elseif dir == 1;
        handles.olddir = 1;
    end
    
    handles.frames = frames;
%     handles = guidata(hObject);
    guidata(hObject,handles);
    
function update_gotoframe(hObject,handles)
    gotoframe = get(handles.gotoframe,'string');
    gotoframe = str2double(gotoframe);
    
    frames = handles.frames;
    
    [~,ind] = min(abs(frames-gotoframe));
    
    frames = circshift(frames,[-1*(ind-1),0]);
    
    handles.frames = frames;
    guidata(hObject,handles);
    
function update_grayout_buttons(hObject,handles)
    tf_playstatus = handles.stop_now;
    
    if tf_playstatus==0
        set(handles.button_play,'enable','off');
        set(handles.button_plus1,'enable','off');
        set(handles.button_minus1,'enable','off');
        set(handles.button_rev,'enable','off');
        set(handles.gotoframe,'enable','off');
        set(handles.fps,'enable','off');
        set(handles.caxis_max,'enable','off');
        set(handles.caxis_min,'enable','off');
    elseif tf_playstatus==1
        set(handles.button_play,'enable','on');
        set(handles.button_plus1,'enable','on');
        set(handles.button_minus1,'enable','on');
        set(handles.button_rev,'enable','on');
        set(handles.gotoframe,'enable','on');
        set(handles.fps,'enable','on');
        set(handles.caxis_max,'enable','on');
        set(handles.caxis_min,'enable','on');
    end

    guidata(hObject,handles);

function caxis_max_Callback(hObject, eventdata, handles)
% hObject    handle to caxis_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caxis_max as text
%        str2double(get(hObject,'String')) returns contents of caxis_max as a double
handles.cmax = str2double(get(handles.caxis_max,'string'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function caxis_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caxis_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function caxis_min_Callback(hObject, eventdata, handles)
% hObject    handle to caxis_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caxis_min as text
%        str2double(get(hObject,'String')) returns contents of caxis_min as a double
handles.cmmin = str2double(get(handles.caxis_min,'string'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function caxis_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caxis_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frame_counter_Callback(hObject, eventdata, handles)
% hObject    handle to frame_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_counter as text
%        str2double(get(hObject,'String')) returns contents of frame_counter as a double


% --- Executes during object creation, after setting all properties.
function frame_counter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gotoframe_Callback(hObject, eventdata, handles)
% hObject    handle to gotoframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gotoframe as text
%        str2double(get(hObject,'String')) returns contents of gotoframe as a double

update_gotoframe(hObject,handles);
handles = guidata(hObject);
update_singleframe(hObject,handles)
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function gotoframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gotoframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fps_Callback(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fps as text
%        str2double(get(hObject,'String')) returns contents of fps as a double


% --- Executes during object creation, after setting all properties.
function fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
