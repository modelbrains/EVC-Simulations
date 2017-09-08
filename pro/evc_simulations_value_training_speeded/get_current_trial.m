%get current trial for change signal task
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

this_inp=zeros(1,stimN);


curr_rews=randperm(8);

%populate options - nondef and def refer to non-default and default options
%- in the speeded version of the task, this doesn't apply, as both options
%are equally likely to have high and low value outcomes
    rp_rews=randperm(8);
    nondef=rp_rews(1:2);
    def=rp_rews(3:4);



curr_rews(1:2)=def(1:2);curr_rews(3:4)=nondef(1:2);

rew_inds=curr_rews;
%set up flags and dynamics for trial

%set reward levels for left and right responses
fix=8.*length_chain+1+8.*length_chain; %trial start

%option 1 - go and change labels are vestigial from the change signal
%version of the PRO model - these now refer to option1 and 2
go1=(rew_inds(1)-1).*length_chain+1;
go2=(rew_inds(2)-1).*length_chain+1;

change1=(rew_inds(3)-1).*length_chain+1+8.*length_chain;
change2=(rew_inds(4)-1).*length_chain+1+8.*length_chain;


changetime=20; %trial iteration in which stimuli are presented

  
%init variables at the beginning of each trial;
    
%vars related to temporal difference model
pred=zeros(1,respN.*outN); %initial TD prediction at the beginning of a trial
last_pred=zeros(1,respN.*outN); %last TD prediction;
last_delay_chain=zeros(size(delay_chain)); %delay chain for recently visited states
elig=zeros(size(delay_chain)); %eligibility trace initially set to zero;
last_elig=elig;    

set_out_flag=0;  %has a response been generated?
ros=0.*ros;      %observed r-o conjunction
end_flag=0;      %flag for ending stimulus presentation
learn_flag=0;    %flag for learning on the first step a r-o conjunction is observed
count=100;       %outcomes are only presented to the model if count is < 20
                 %when a new outcome is observed (interpret_response.m),
                 %count is set to 0.  This variable increments +1 on each
                 %model iteration.

valence=0;        %init valence (no outcomes observed yet, so no valence);
act_out=zeros(1,respN); %response unit activity

omegaN_cat=[];  %init variables for storing data on each iteration
omegaP_cat=[];
