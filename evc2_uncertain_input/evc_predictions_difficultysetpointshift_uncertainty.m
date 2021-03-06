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
effortsign=sign(effort);
% effort=effort_abs.*effortsign;

effort_bu=effort;
effort=abs(effort);
 
%%%In this version of the script, probabilities are calculated in the loop
%%%(see ~line 67-67
% p_opt1_given_effort=0.0:.01:1; %probability of choosing option 1 for a given effort level
% p_opt2_given_effort=fliplr(p_opt1_given_effort); %probability of choosing option 2 for a given effort level

gamma=thisgamma; %from batch_setpointshift.m - parameter controlling how increases in value difference influence the probability of success
%generally the idea is that increases in value differences make the choice
%task easier - that is, for a given level of effort, the probability of
%making the "best" choice (highest expected value) is higher for high value
%differences vs low value value differences


%define possible values for the value-based choice task
value_increment=5;
values=[10:value_increment:80];%possible values of o1 and o2
maxdiff=values(end)-values(1); %maximum difference in value of each option


trialN=10000; %number of trials

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

%add uncertainty by varying the expected value of each option - there are
%multiple ways of doing this; probably the most conservative would be to
%suggest that the subjective estimate of uncertainty is somewhere in the
%range between the maximum and minimum outcome of each option, i.e., the
%subjective estimate is drawn from a uniform distribution bounded by the
%max and min of each option.
opt1_unc=[min(values(vsind(1)), values(vsind(2))):max(values(vsind(1)),  values(vsind(2)))];
opt2_unc=[min(values(vsind(3)), values(vsind(4))):max(values(vsind(3)),  values(vsind(4)))];

%we can do this with every value between the min and max for each option,
%but that slows things way down.  So let's select at most 5 samples from
%each distribution.  This doesn't really change anything, but the at least
%it runs more quickly

if length(opt1_unc)>5   
    opt1_unc=randsample(opt1_unc,5);
end
if length(opt2_unc)>5
    opt2_unc=randsample(opt2_unc, 5);
end


unc_count=0;
p_opt1_given_effort=0;

for opt1_est=opt1_unc;
    for opt2_est=opt2_unc;
        unc_count=unc_count+1;
        
        ev1r=(opt1_est);
        ev2r=(opt2_est);

%the term (ev1-ev2)./gamma below adjusts the point at which the model is equally
%likely to choose between two options.  e.g., when ev1>ev2, the model would
%have to exert effort in for option 2 in order to have a probability of .5
%for selecting either option - gamma is defined in batch_setpointshift.m
p_opt1_given_effort=p_opt1_given_effort+(1./(1+exp(-effort_bu+(((ev1r-ev2r))./gamma))));
    end
end

p_opt1_given_effort=p_opt1_given_effort./unc_count;

p_opt2_given_effort=1-p_opt1_given_effort;

%calculate candidate control signals as per shenhav 2013 eq 1
signal=p_opt1_given_effort.*ev1r+p_opt2_given_effort.*ev2r-effort;

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
xlabel('value difference (option 1 - option 2)')
ylabel('Activity (Arbitrary Units)')
title('EVC Predictions')
drawnow