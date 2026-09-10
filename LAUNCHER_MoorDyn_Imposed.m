clear all
close all
clc

%% Load Data
load 094_cutted
IMAX=3000;
dt = Res.Time(2)-Res.Time(1);

% input kineamtic, 6xlength(N)
kin(:,1) = Res.Surge;           % Surge [m]
kin(:,2) = Res.Sway;            % Sway [m]
kin(:,3) = Res.Heave;           % Heave [m]

kin(:,4) = deg2rad(Res.Roll);    % Roll [rad]
kin(:,5) = deg2rad(Res.Pitch);   % Pitch [rad]
kin(:,6) = deg2rad(Res.Yaw);     % Yaw [rad]

kin=kin(1:IMAX,:);

%% Launch MoorDyn Simulation kin MUST BE N X 6
FUNC_MoorDyn_imposed(dt,kin)
