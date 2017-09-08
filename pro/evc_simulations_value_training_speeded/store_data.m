%store_data - stores data from trial that we just finished.
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

this=find(ros>0);  %find which ro conjunction we just had
vdiff=(curr_rews(1)+curr_rews(2))./2 - (curr_rews(3)+curr_rews(4))./2;


rts=ones(respN.*outN,1).*rt; %index reaction times
tN=ones(respN.*outN,1).*i;

omegaN_cat=[rt vdiff sum(omegaN_cat) tN(1)];
omegaP_cat=[rt vdiff sum(omegaP_cat) tN(1)];

omegaN_all=[omegaN_all; omegaN_cat];
omegaP_all=[omegaP_all; omegaP_cat];


        
        
            
            