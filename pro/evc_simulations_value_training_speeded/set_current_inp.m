%set_current_inp - handles presentation of fixation, option stimuli, update of TD
%delay chains, and update of eligibility traces
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


if j<length_chain %if j is greater than the length of the delay chain, trial's over
            fixdelay=j+fix; %display fixation
    
            this_go_delay=j+go1; %indexes current go delay
            this_go_delay2=j+go2;
            this_change_delay=j-changetime+change1; %if so, index it;
            this_change_delay2=j-changetime+change2;
            this_inp(17)=1;

            if (j-changetime)>=-1 %Is the current option set on display yet?
      
            this_inp(rew_inds(1))=1;
            this_inp(rew_inds(2))=1;
            this_inp(rew_inds(3)+8)=1;
            this_inp(rew_inds(4)+8)=1;
            delay_chain=delay_chain.*0;
            delay_chain(this_go_delay)=1;delay_chain(this_change_delay)=1; 
            delay_chain(this_go_delay2)=1;delay_chain(this_change_delay2)=1; 
          

            else
          delay_chain=delay_chain.*0;%reset delay_chain in order to cleanly insert new indices
            end
         delay_chain(fixdelay)=1;
        else
        delay_chain=delay_chain.*0;%shut off delay chain if it's past the limit
        this_inp=0.*this_inp; %stimuli are shut off
        
end
        this_inp(1:8)=this_inp(1:8);
        this_inp(9:16)=this_inp(9:16);
        delay_chain(1:length_chain.*8)=delay_chain(1:length_chain.*8);
delay_chain(length_chain.*8:length_chain.*16)=delay_chain(length_chain.*8:length_chain.*16);