function  FUNC_MoorDyn_imposed(dt,kin)

%% Close MoorDyn if already loaded
try
    calllib('MoorDyn','LinesClose');      
    unloadlibrary MoorDyn;              
catch
end

%% Initialization
kin_d= diff(kin)./dt;
X = kin(1,:)';   % update position and velocity each time step
XD = kin_d(1,:)';

loadlibrary('MoorDyn','MoorDyn.h');     % load MoorDyn DLL
calllib('MoorDyn','LinesInit',X,XD)   % initialize MoorDyn 
libfunctions('MoorDyn', '-full');

%% Simulation

N=length(kin);
FairTens1 = zeros(N+1,1);           % array for storing fairlead 1 tension time series
FLines_temp = zeros(1,6);           % going to make a pointer so LinesCalc can modify FLines
FLines_p = libpointer('doublePtr',FLines_temp);  % access returned value with FLines_p.value
Ts = zeros(N,1);                    % time step array  

for i=1:N-1        
    calllib('MoorDyn', 'LinesCalc', X, XD, FLines_p, Ts(i), dt);  % some MoorDyn time stepping
    FairTens1(i+1) = calllib('MoorDyn','GetFairTen',1);           % store fairlead 1 tension
    X= kin (i,:)';
    XD = kin_d(i,:)';
    Ts(i+1) = dt*i;                 % store time
end
    
%% Ending
calllib('MoorDyn','LinesClose');       % close MoorDyn
unloadlibrary MoorDyn;              % unload library (never forget to do this!)

end