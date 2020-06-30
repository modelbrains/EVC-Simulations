%Batch Script for Expected Value of Control 2 - Shenhav et al., 2013
%     Copyright 2017 Will Alexander
%   
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.        



%parameter governing how differences in expected value between options
%change the point at which the EVC model is equally likely to choose
%between two options.
gammas=[.1 2:2:10];

gamma_labels={};
runs=20;
gammaruns=zeros(size(gammas,1),29);
allgm=0; %variable for storing results of each run

for mm=1:runs
    disp(['run: ' num2str(mm)]);
    
    gammamat=[];%variable for storing results for values of gamma
for ll=1:length(gammas)
    thisexp=1;
    thisgamma=gammas(ll);
    
    %run EVC2 model
    evc_predictions_foraging
    
    gammamat=[gammamat;mean_sig];
    gamma_labels{ll} = ['gamma = ' num2str(thisgamma)];
    
end
%save run results
gammacount=~isnan(gammamat);
gammaruns=gammaruns+gammacount;

gammamat(isnan(gammamat))=0;

allgm=allgm+gammamat;
end
%mean results
allgm=allgm./gammaruns;
allgm=fliplr(allgm);
%display figure from online methods.
close all
line_colors=zeros(length(gammas),3);
greenval=linspace(0, .9, length(gammas));
line_colors(:,2)=greenval';
for i=1:length(gammas)
plot(index_sig,allgm(i,:), 'color',line_colors(i,:), 'LineWidth', 2)
hold on
end
set(gcf, 'Color', 'white')
xlabel('Value Difference (Forage - Engage)')
yticks([])
box off
set(gca,'TickLength',[0 0], 'FontSize', 14, 'FontWeight', 'bold')
ylabel('Model Activity (A.U.)')
title('Vassena et al. 2020 Implementation of EVC')
legend(gamma_labels, 'Location', 'NorthWest')

