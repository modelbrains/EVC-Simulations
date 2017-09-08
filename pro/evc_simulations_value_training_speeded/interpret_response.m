%interpret_response - when a response is generated, update predictions of r-o
%conjunctions and top-down control weights
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


            set_out_flag=1; %We have a response!
            learn_flag=1; %and we should start learning something
            output=find(resp==max(resp)); %What response did we make?
            act_out(output)=1; %register which output actually occurred.
            rt=j; %keeps track of reaction time
            
            %output 1 = left
            %output 2 = right
            
            if output==1 %model chose option 1,%let's call this left

                  r_fbackpos=curr_rews(1);
                  r_fbackneg=0;
                  ros(1)=curr_rews(1);
                if rand>.5
                    ros(1)=curr_rews(1).*1;
                    r_fbackpos=curr_rews(1);
                    r_fbackneg=curr_rews(2);
                    else

                    ros(1)=curr_rews(2).*1;
                    r_fbackpos=curr_rews(2);
                    r_fbackneg=curr_rews(1);
                end

              valence=r_fbackpos;

                err=0;
                if valence>0;
                err=1;
                else
                err=0;
                end
            end
            if output==2 %model chose right

                  r_fbackpos=curr_rews(2);
                  r_fbackneg=0;
                    ros(2)=curr_rews(2);
                if rand>.5
                    ros(2)=curr_rews(3).*1;
                    r_fbackpos=curr_rews(3);
                    r_fbackneg=curr_rews(4);
                else
                    ros(2)=curr_rews(4).*1;
                    r_fbackpos=curr_rews(4);
                    r_fbackneg=curr_rews(3);
                end
             valence=r_fbackpos;

                    err=0;
                if valence>0;
                    err=1;
                else
                    err=0;
                end
            end
            %due to the somewhat strained logic that went into coding this,
            %positive valence is the same as error commission - the model
            %made a mistake and should learn from it.
             valence=-valence.*.01;
                if valence>0;
                err=1;
                else
                    err=0;
                end

            ros=ros.*1;
            count = 0; %set count to 0 to indicate beginning of outcome presentation to model.