clear all, close all

filename = 'annealed steel 10-22'; 
sampleData = importdata([filename '.txt'],',',7); % import data from txt file, skip the first 7 lines
Time = sampleData.data(:,1); 

% load data into different arrays
Load = sampleData.data(:,2);
Extension = sampleData.data(:,3); % extension data
Crosshead = sampleData.data(:,4); % crosshead data
Extensometer = sampleData.data(:,5); % extensometer data
gaugeLength = 2; % value from lab manual
sampleArea = 0.125*0.375; % value from lab manual
EStrain = Extension/gaugeLength; % strain formula defined
EStress = Load/sampleArea; % stress formula defined

% Get the Range for the Stress vs. Strain Curve
figure, p = plot([Extension,Crosshead,Extensometer]); title('Elongation(in.) Vs. Load(lbf)');
xlabel('Sample Number'); ylabel('Response (in)'); legend('Extension','Crosshead','Extensometer');
p(1).LineWidth = 1.25; p(2).LineWidth = 1.25; p(3).LineWidth = 1.25;

% Plot Stress-Strain Curve
NE = 400; % range to calculate the elasticity, this is picked off the previous plot
NY = 6329; % range to plot, this is picked off the previous plot
figure, hold on;
plot(EStrain(1:NY),EStress(1:NY),'r') % plot stress-strain curve with the whole range NY
xlim([-.025 .4])

% Plot E line within the elastic region
E = (EStress(NE)-EStress(1))/(EStrain(NE)-EStrain(1)); % compute slope E within elasticity range NE
Eline = [0,0;EStress(NE)/E,EStress(NE)]; % define E line with x,y locations at each end
plot(Eline(:,1),Eline(:,2),'b'); % plot E line onto the stress-strain curve
grid on; xlabel('Engineering Strain (in/in)'); ylabel('Engineering Stress (psi)');
title('Group 10 Annealed Steel Engineering Strain vs. Engineering Stress');

% plot offset line and yield stress
% offsetline = [0.002,0;EStress(NE)/E+.002,EStress(NE)+1000];
% [x, y] = polyxpoly(offsetline(:,1),offsetline(:,2),EStrain,EStress);
% yieldStress = y;
% plot(offsetline(:,1),offsetline(:,2),'k-')
% plot(x,yieldStress,'bo'); % yield stress

% yield stress
x = 0.00171; y = 51919.7; plot(x,y,'bo');
% plot ult stress point
ult_stress = max(EStress); max = find(EStress == ult_stress); hold on;
yieldStress = plot(EStrain(max),EStress(max),'g*');

% fracture point
plot(EStrain(6320),EStress(6320),'b*')

legend('Test Data','E Computation Region','Yield Stress','Ultimate Stress','Failure Stress','Location','Best')

sigmaI = EStrain(1:NE)*E;
sigmaA = EStress(1:NE);
SSE = sum((sigmaI-sigmaA).^2);
SST = sum((sigmaI-mean(sigmaA)).^2);
Rsquared = 1-(SSE/SST);
text(0.25,4.6*10^4,sprintf('R^{2} = %.5f',Rsquared))

ult_stress;
yieldStress;

integral = trapz(EStrain(1:NY),EStress(1:NY))

% No offset line for annealed steel because they would just be the same