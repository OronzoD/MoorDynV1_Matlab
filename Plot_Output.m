clear all
close all
clc

%% PLOT OPTIONS
plotflagTIME = 0;
screenSize = get(groot,'ScreenSize');
figWidth  = 1000;
figHeight = 500;
figX = (screenSize(3) - figWidth)/2;
figY = (screenSize(4) - figHeight)/2;

%% LOADING DATA
cd Mooring\
delete *.csv
load 094_cutted  
N=6;
for ii=1:N
    copyfile(['Line',num2str(ii),'.out'],['Line',num2str(ii),'.csv'])
end
files_name= dir('Line*.csv');
counter=1;

LC1=readmatrix('Line1.csv');
LC2=readmatrix('Line2.csv');
LC3=readmatrix('Line3.csv');

%% Mooring Line 1

figure()

plot(Res.Time, ...
     Res.MooringLine1, ...
     'LineWidth',1.5)

hold on

plot(LC1(:,1),LC1(:,end), ...
     'LineWidth',1.5)

ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';

xlabel('$t$ (s)', ...
    'Interpreter','latex', ...
    'FontSize',24)

ylabel('Force (N)', ...
    'Interpreter','latex', ...
    'FontSize',24)

legend('Experimental','MoorDyn', ...
    'Interpreter','latex', ...
    'FontSize',18, ...
    'Location','best')


%% Mooring Line 2

figure()

plot(Res.Time, ...
     Res.MooringLine2, ...
     'LineWidth',1.5)

hold on

plot(LC2(:,1),LC2(:,end), ...
     'LineWidth',1.5)

ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';

xlabel('$t$ (s)', ...
    'Interpreter','latex', ...
    'FontSize',24)

ylabel('Force (N)', ...
    'Interpreter','latex', ...
    'FontSize',24)

legend('Experimental','MoorDyn', ...
    'Interpreter','latex', ...
    'FontSize',18, ...
    'Location','best')


%% Mooring Line 3

figure()

plot(Res.Time, ...
     Res.MooringLine3, ...
     'LineWidth',1.5)

hold on

plot(LC3(:,1),LC3(:,end), ...
     'LineWidth',1.5)

ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';

xlabel('$t$ (s)', ...
    'Interpreter','latex', ...
    'FontSize',24)

ylabel('Force (N)', ...
    'Interpreter','latex', ...
    'FontSize',24)

legend('Experimental','MoorDyn', ...
    'Interpreter','latex', ...
    'FontSize',18, ...
    'Location','best')

%% READ ALL THE POSITION OF THE NODES FOR EACH TIME STEP

for ii=1:N
    temp=readmatrix(['Line',num2str(ii),'.csv']);
    data.(['Line',num2str(ii)]).K=size(temp,2)/4;
    K=data.(['Line',num2str(ii)]).K;
    for kk=1:K
        data.(['Line',num2str(ii)]).position.(['node',num2str(kk)]).x=temp(:,(kk-1)*3+2);
        data.(['Line',num2str(ii)]).position.(['node',num2str(kk)]).y=temp(:,(kk-1)*3+3);
        data.(['Line',num2str(ii)]).position.(['node',num2str(kk)]).z=temp(:,(kk-1)*3+4);
        data.position_x(:,counter)=temp(:,(kk-1)*3+2);
        data.position_y(:,counter)=temp(:,(kk-1)*3+3);
        data.position_z(:,counter)=temp(:,(kk-1)*3+4);
        counter=counter+1;
    end
    time=temp(:,1);
    M=length(temp(:,1));
end


%% PLOT IN TIME OF THE LINES

if plotflagTIME == 1
    figure('Position',[figX figY figWidth figHeight])

    % Plot first frame
    h = plot(data.position_x(1,:), ...
             data.position_z(1,:), ...
             '.', 'MarkerSize',12);

    % Axes settings
    ax = gca;
    ax.FontSize = 18;
    ax.TickLabelInterpreter = 'latex';

    grid on
    axis equal

    % Labels
    xlabel('$X$ (m)', ...
        'Interpreter','latex', ...
        'FontSize',24)

    ylabel('$Z$ (m)', ...
        'Interpreter','latex', ...
        'FontSize',24)

    % Set maximum Z limit to zero
    yl = ylim;
    ylim([yl(1) 0])

    for ii = 1:M

        % Update particle positions
        h.XData = data.position_x(ii,:);
        h.YData = data.position_z(ii,:);

        % Title
        title(['Time $= ', num2str(ii*time(2)), '\ \mathrm{s}$'], ...
            'Interpreter','latex', ...
            'FontSize',22)

        drawnow
        pause(0.00001)
    end
end

cd ..