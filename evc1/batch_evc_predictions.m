%Batch Script for Expected Value of Control - Shenhav et al., 2013
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

exp_effs=[.5 1 2]; %values for exponentiation of effort costs
betas=[.1 .5 10]; %gain for softmax
sig_cat=[]; %vector for concatenating optimal control signals
index_cat=[]; %vector for concatenating trial types (value differences between option 1 and 2)

subplot_count=0; %index for displaying model output

for eE=1:length(exp_effs); %loop through effort functions
    for bE=1:length(betas); %loop through softmax gains
        subplot_count=subplot_count+1;
        
        ceE=exp_effs(eE); %current cost function parameter
        cbE=betas(bE); %current gain parameter
        
        %run EVC
        evc_predictions
        %store variables from each run
        sig_cat=[sig_cat;mean_sig];
        index_cat=[index_cat;index_sig];
    end
end