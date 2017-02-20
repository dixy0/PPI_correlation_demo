% This script is to show the correlations between PPI terms (psychophysiological
% interaction) cauclated from two methods. One with deconvolution and the
% other without deconvoution. We will show that the PPI correlations is a
% function task design frequency. 
% Author: Xin Di, PhD.
clear

num_simulation = 1000; % Number of simulations: 1000
N = 180; % length of time series in scan
TR = 2; % repetition time

% Define psych variables: block design with simple on and off periods
c_range = 8:8:80;  % cycle range
for ci = 1:length(c_range)
    psy_temp = [];
    for di = 1:ceil(N*TR/c_range(ci))
        psy_temp = [psy_temp;zeros(c_range(ci)/TR/2,1);ones(c_range(ci)/TR/2,1)];
    end
    psy_block(:,ci) = psy_temp(1:N);
end

% Define psych variables: event-related design
% One time bin (2 s) of event and five time bin (10 s) of baseline
psy_temp = [];
for di = 1:ceil(N*TR/12)
    psy_temp = [psy_temp;zeros(5,1);ones(1,1)];
end
psy_event = psy_temp(1:N);

% Call SPM function spm_hrf to define canonical HRF: 
% hrf = spm_hrf(2);
hrf = [0;0.0865660809936357;0.374888236471690;0.384923381745461;0.216117315646557;0.0768695652550848;0.00162017719800089;-0.0306078117340448;-0.0373060781329993;-0.0308373715988730;-0.0205161333521205;-0.0116441637490611;-0.00582063147182588;-0.00261854249818620;-0.00107732374408556;-0.000410443522357321;-0.000146257506876445;];

% Convovlution of psychological variable with HRF
for ci = 1:length(c_range)
    psy_con_temp = conv(psy_block(:,ci),hrf);
    psy_block_con(:,ci) = psy_con_temp(1:N);
end

psy_con_temp = conv(psy_event,hrf);
psy_event_con = psy_con_temp(1:N);

% Generating the physiological variable by using Gaussian random variable.
% Calculating PPI terms using deconvolution and non-deconvolution methods.
% And Calculate correlations of PPI terms between the two methods.
for i = 1:num_simulation
    % define physiological variable
    phy = randn(N,1);
    phy = detrend(phy,'constant');  % centering the physio variable
    
    phy_con = conv(phy,hrf);
    phy_con = phy_con(1:N);
    
    for ci = 1:length(c_range)
        con_ppi = detrend(psy_block_con(:,ci),'constant').*detrend(phy_con,'constant');   % PPI without deconvolution
        ppi = detrend(psy_block(:,ci),'constant').*phy;  % PPI with deconvolution
        ppi_con = conv(ppi,hrf);
        ppi_con = ppi_con(1:N);
        
        corr_ppi_block(i,ci) = corr2(ppi_con,con_ppi);  % correlation between the psych variable and PPI without centering
    end
   
    con_ppi = detrend(psy_event_con,'constant').*detrend(phy_con,'constant');   % PPI without deconvolution
    ppi = detrend(psy_event,'constant').*phy;  % PPI with deconvolution
    ppi_con = conv(ppi,hrf);
    ppi_con = ppi_con(1:N);
    
    corr_ppi_event(i,1) = corr2(ppi_con,con_ppi);  % correlation between the psych variable and PPI without centering
    
end

% Make figure
figure; 
subplot(1,2,1)
imagesc([psy_event psy_block])
set(gca,'fontsize',14); colormap('gray');
xlabel('Design cycle (secs)'); ylabel('Time (scan)');
subplot(1,2,2)
boxplot([corr_ppi_event,corr_ppi_block],[0 c_range])
set(gca,'fontsize',14)
xlabel('Design cycle (secs)'); ylabel('Correlation');

