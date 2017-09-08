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
% al., 2013.


effort=(-5:.1:5); %costs of control for selecting one option (left/right) 
                     %over another; as control increases, so does the cost
effort_bu=effort; %maintain a copy of the effort costs
effort=abs(effort); %absolute effort

effort=effort.^ceE; %exponentiation from batch wrapper batch_evc_predictions.m

%calculate softmax probability of selecting option 1 for all effort levels
%and a given gain parameter (cbE from batch_evc_predictions.m)
p_opt1_given_effort=1./(1+exp(-effort_bu.*cbE));
p_opt2_given_effort=fliplr(p_opt1_given_effort); %probability of choosing option 2 for a given effort level

%N.B.  The above definitions rest on the assumptions that:
%        1: The cost of control increases monotonically with the 
%           amount/intensity of control 
%        2: The probability of making a controlled-for response increases
%           montonically with the amount/intensity of control
% The relationship between control and cost and probability are linear -
% this need not be the case - if the relationship is made non-linear (e.g.,
% through exponentiation of effort or probability), the predictions made by
% EVC model are always U-shaped or flat, but never an inverted U.  This is
% in contrast with the Choice Difficulty account (Shenhav et al.,
% 2014;2016)

%define possible values for the value-based choice task
value_increment=5;
values=[10:value_increment:80];%possible values of o1 and o2
maxdiff=values(end)-values(1); %maximum difference in value of each option

trialN=100000; %number of trials

%vectors for data storage
signal_vec=zeros(1,trialN);%vector to store optimum signal
value_difference_vec=zeros(1,trialN);%vector to store value difference
choice_difficulty_vec=zeros(1,trialN); %vector to store choice difficulty 


for i=1:trialN;%loop through trials
    %choose values for each option - each option consists of two possible
    %outcomes, with a 50% chance of either outcome given a selected option.
    vsind=randperm(length(values));
    ev1=(values(vsind(1))+values(vsind(2)))./2;%expected value of option 1
    ev2=(values(vsind(3))+values(vsind(4)))./2;%expected value of option 2
    
value_difference_vec(i)=ev1-ev2;

current_choice_difficulty=((-(abs(value_difference_vec(i)))+maxdiff)); %adding maxdiff sets the range to be positive
choice_difficulty_vec(i)=current_choice_difficulty;

%calculate candidate control signals as per shenhav 2013 eq 1
signal=p_opt1_given_effort.*ev1+p_opt2_given_effort.*ev2-effort;

%shenhav 2013 eq. 3
signal_vec(i)=max(signal);

end %trials finished

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
subplot(length(exp_effs), length(betas), subplot_count) %subplot_count from batch_evc_predictions
plot(index_sig, mean_sig)
xlabel('value difference (option 1 - option 2)')
ylabel('Activity (Arbitrary Units)')
title('EVC Predictions')
legend(['eff exp = ' num2str(ceE) '; beta = ' num2str(cbE)])