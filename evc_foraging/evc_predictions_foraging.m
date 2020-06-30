%Expected Value of Control - Shenhav et al., 2013
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

% Implements the Expected Value of Control Model described in Shenhav et
% al., 2013.  Here, we apply it to the KBMR/Shenhav et al 2014 foraging
% task

effort=(-8:.1:2); %costs of control for selecting one option (left/right) 
                  %over another; as control increases, so does the cost
                  %Default (engage) responses are assumed to be less
                  %effortful than foraging responses
  

effortsign=sign(effort);

effort_bu=effort;
effort=abs(effort);

gamma=thisgamma; %from batch_setpointshift.m - parameter controlling how 
%increases in value difference influence the probability of success
%generally the idea is that increases in value differences make the choice
%task easier - that is, for a given level of effort, the probability of
%making the "best" choice (highest expected value) is higher for high value
%differences vs low value value differences


%define possible values for the value-based choice task
value_increment=5;
values=[10:value_increment:80];%possible values of o1 and o2
maxdiff=values(end)-values(1); %maximum difference in value of each option


trialN=1000; %number of trials

%vectors for data storage
signal_vec=zeros(1,trialN);%vector to store optimum signal
value_difference_vec=zeros(1,trialN);%vector to store value difference
choice_difficulty_vec=zeros(1,trialN); %vector to store choice difficulty 


for i=1:trialN;%loop through trials
    %choose values for each option - each option consists of two possible
    %outcomes, with a 50% chance of either outcome given a selected option.
    vsind=randperm(length(values));
    
    ev_forage=mean(values(vsind(1:6)));
    ev_engage=mean(values(vsind(7:8)));
%     ev1=(values(vsind(1))+values(vsind(2)))./2;%expected value of option 1
%     ev2=(values(vsind(3))+values(vsind(4)))./2;%expected value of option 2
    
value_difference_vec(i)=ev_forage-ev_engage;

%the term (ev_engage-ev_forage)./gamma below adjusts the point at which the model is equally
%likely to choose between two options.  e.g., when ev_engage>ev_forage, the model would
%have to exert effort for option 2 in order to have a probability of .5
%for selecting either option - gamma is defined in batch_setpointshift.m
p_forage_given_effort=(1./(1+exp(-effort_bu+(((ev_forage-ev_engage))./gamma))));
p_engage_given_effort=(1-p_forage_given_effort);

%calculate candidate control signals as per shenhav 2013 eq 1
signal=p_engage_given_effort.*ev_engage+p_forage_given_effort.*ev_forage-effort;


%shenhav 2013 eq. 3
signal_vec(i)=max(signal);

end

%process and store data
%get the mean activity
mean_sig=zeros(size([-maxdiff:value_increment:maxdiff]));
index_sig=[];
count=1;
for i=-maxdiff:value_increment:maxdiff
mean_sig(count)=mean(signal_vec(value_difference_vec==i)); %get the mean signal for choice between options with a specific value difference
index_sig=[index_sig i];
count=count+1;

end

%now plot it
plot(index_sig, mean_sig)
xlabel('value difference (engage - forage)')
ylabel('Activity (Arbitrary Units)')
title('EVC Predictions')
drawnow