%Batch Script for PRO model - speeded value-based choice task
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



%variables for storing data
vals=[];
catrts=[];
valsresp=[];

%condition labels
lbls={'xn6', 'xn55', 'xn5', 'xn45', 'xn4', 'xn35', 'xn3', 'xn25', 'xn2', 'xn15', 'xn1', 'xnp5',...
'x6', 'x55', 'x5', 'x45', 'x4', 'x35', 'x3', 'x25', 'x2', 'x15', 'x1', 'xp5'};

for subs=1:10

    %variables for storing condition data
tmp=[];
tmprt=[];

%run the PRO model
pro_model_evc_training_speeded

%process data
evc_valuedifferences

%concatenate model activity by condition from stimulus onset
tmp=[sum(mean(omegaN_all(xn6, 21:30))) sum(mean(omegaN_all(xn55, 21:30))) sum(mean(omegaN_all(xn5, 21:30))) sum(mean(omegaN_all(xn45, 21:30))) sum(mean(omegaN_all(xn4, 21:30))) sum(mean(omegaN_all(xn35, 21:30))) sum(mean(omegaN_all(xn3, 21:30))) sum(mean(omegaN_all(xn25, 21:30))) sum(mean(omegaN_all(xn2, 21:30))) sum(mean(omegaN_all(xn15, 21:30))) sum(mean(omegaN_all(xn1, 21:30))) sum(mean(omegaN_all(xnp5, 21:30)))...
sum(mean(omegaN_all(x6, 21:30))) sum(mean(omegaN_all(x55, 21:30))) sum(mean(omegaN_all(x5, 21:30))) sum(mean(omegaN_all(x45, 21:30))) sum(mean(omegaN_all(x4, 21:30))) sum(mean(omegaN_all(x35, 21:30))) sum(mean(omegaN_all(x3, 21:30))) sum(mean(omegaN_all(x25, 21:30))) sum(mean(omegaN_all(x2, 21:30))) sum(mean(omegaN_all(x15, 21:30))) sum(mean(omegaN_all(x1, 21:30))) sum(mean(omegaN_all(xp5, 21:30)))];

tmp(13:24)=fliplr(tmp(13:24));

%concatenate model activity by condition from response time
tmpresp=[];
for i=1:length(lbls)

eval(['thisun=' lbls{i} ';']);

thisunrts=omegaN_all(thisun,1);

tmp_oN_resp=[];
for j=1:length(thisunrts)
    tmp_oN_resp=[tmp_oN_resp; omegaN_all(thisun(j), thisunrts(j)+1:thisunrts(j)+10)];
end
    tmpresp=[tmpresp sum(mean(tmp_oN_resp))];
end

tmpresp(13:24)=fliplr(tmpresp(13:24));

tmprt=[sum(mean(omegaN_all(xn6, 1))) sum(mean(omegaN_all(xn55, 1))) sum(mean(omegaN_all(xn5, 1))) sum(mean(omegaN_all(xn45, 1))) sum(mean(omegaN_all(xn4, 1))) sum(mean(omegaN_all(xn35, 1))) sum(mean(omegaN_all(xn3, 1))) sum(mean(omegaN_all(xn25, 1))) sum(mean(omegaN_all(xn2, 1))) sum(mean(omegaN_all(xn15, 1))) sum(mean(omegaN_all(xn1, 1))) sum(mean(omegaN_all(xnp5, 1)))...
sum(mean(omegaN_all(x6, 1))) sum(mean(omegaN_all(x55, 1))) sum(mean(omegaN_all(x5, 1))) sum(mean(omegaN_all(x45, 1))) sum(mean(omegaN_all(x4, 1))) sum(mean(omegaN_all(x35, 1))) sum(mean(omegaN_all(x3, 1))) sum(mean(omegaN_all(x25, 1))) sum(mean(omegaN_all(x2, 1))) sum(mean(omegaN_all(x15, 1))) sum(mean(omegaN_all(x1, 1))) sum(mean(omegaN_all(xp5, 1)))];
tmprt(13:24)=fliplr(tmprt(13:24));

catrts=[catrts; tmprt];
vals=[vals; tmp];
valsresp=[valsresp; tmpresp];

% % % save data from each individual run, if you're into that sort of thing
% % % eval(['save evc_simulations_value_training_speeded/sub_' num2str(subs) '_speeded.mat conj2resp stim2temporal stim2conj']);


%plot data 
close all
if subs>1
figure(1)
plot(mean(vals))
title('Stimulus-locked Activity')
drawnow
figure(2)
plot(mean(catrts));
title('Response-locked Activity')
drawnow
else
figure(1)
plot(vals)
title('Stimulus-locked Activity')
figure(2)
plot(catrts)
title('Response-locked Activity')
drawnow
end
end %end subject loop

save group_data.mat vals catrts