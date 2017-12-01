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
gammas=[.1 2:2:20];

gamma_labels={};
runs=10;
allgm=0; %variable for storing results of each run

for mm=1:runs
    disp(['run: ' num2str(mm)]);
    
    gammamat=[];%variable for storing results for values of gamma
for ll=1:length(gammas)
    thisexp=1;
    thisgamma=gammas(ll);
    
    %run EVC2 model
    evc_predictions_difficultysetpointshift_alt_control
    gammamat=[gammamat;mean_sig];
    gamma_labels{ll} = ['gamma = ' num2str(thisgamma)];
    
end
%save run results
allgm=allgm+gammamat;
end
%mean results
allgm=allgm./runs;

%display figure from online methods.
close all
plot(allgm')
legend(gamma_labels)

