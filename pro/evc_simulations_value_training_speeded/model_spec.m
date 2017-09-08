%Specification of model parameters and such
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


%%simulation parameters
dt=0.01;            %length of each iteration of the model in seconds
trial_length=2.25;     %length of each trial in seconds;

%experiment parameters
trialN=3000;         %number of trials in an experiment
stimN=17;            %total number of potential stimuli 
                     %   - 8 total stimuli that may appear on left or right, 1 fixation point 
respN=2;            %total number of potential responses (e.g., option1/option2)
outN=1;     %val left, val right        %total number of potential feedback signals (e.g., correct/error)


%model parameters
    %TD model
alphaTD=0.01;        %learning rate for Temporal Difference Model
gammaTD=.95;       %discount rate for TD model
elig=0.95;          %eligibility trace decay
length_chain=200;   %total number of time steps a temporal representation 
                    %of a stimulus is active.
delay_chain=zeros(1, length_chain.*stimN); %delay chain used for TD model                    

   
threshold =x(1);  %threshold for response units.
alpharos=x(2);     %learning rate for updating Response-Outcome probabilities
rho=x(3);          %multiplier for dynamic response units
phi=x(4);          %multiplier for dynamic response inhibition
psi=x(5);
noise=x(6); %variance of response unit noise
rate=x(7);
lscale=1;


%set up weight matrices and various indices
stim2resp=zeros(stimN,respN);  %hardwired weights from task stimuli to response units
stim2resp(1:8,1)=[.05:.05:.4];
stim2resp(9:16,2)=[.05:.05:.4];
stim2resp=stim2resp.*2;
stim2resp(end,:)=[-.1 -.1];

mut_inhib=eye(respN);%mutual inhibition of response weights
    mut_inhib=(mut_inhib-1).*-1;
    
stim2conj=zeros(stimN, respN.*outN);  %stimulus to response-outcome predictions

stim2temporal=zeros(respN.*outN, length_chain.*stimN); %stimulus to temporal prediction weights

conj2resp=zeros(respN.*outN, respN); %top-down control weights

resp=zeros(1,respN);    %activity of response units
ros=zeros(1,respN.*outN);  %index of response-outcome conjunctions
    
   