function project_driver
%% PART ONE 
% When perform the handshake game to a University class with around 300 
% students: 
%
% Parameter Configurations: 
% # handshakes = 10;
% infectious period = 5;
% # initial infectives: 1

clc

[largeUni, smallUni, HighSchool] = import_data_from_txt_files();

num_data_set_1 = 20;
for i  = 1 : num_data_set_1
    figure(i); 
    fprintf('For Figure %d: \n', i);
    SIR_optimisation_stages(largeUni{i});
end


%% PART TWO
% When perform the handshake game to a University class with around 70 
% students:
%
% For figures (1) - (2): 
% # handshakes = 7;
% infectious period = 3.
%
% For figure (3) - (4): 
% # handshakes = 7;
% infectious period = 5.
%
% For figure (5) - (6): 
% # handshakes = 10;
% infectious period = 3
%
% For figure (7) - (8): 
% # handshakes = 7;
% infectious period = 7


clc

[largeUni, smallUni, HighSchool] = import_data_from_txt_files();

num_data_set_2 = 8;
for i  = 1 : num_data_set_2
    figure(i);
    fprintf('For Figure %d: \n', i);
    SIR_optimisation_stages(smallUni{i});
end


%% PART THREE
% When perform the handshake game to a highschool class with around 30 
% students:
%
% For figures (1) - (2), (5): 
% # handshakes = 6;
% infectious period = 3.
%
% For figures (3) - (4): 
% # handshakes = 5;
% infectious period = 5.

clc

[largeUni, smallUni, HighSchool] = import_data_from_txt_files();

num_data_set_3 = 5;
for i  = 1 : num_data_set_3
    figure(i);
    fprintf('For Figure %d: \n', i);
    SIR_optimisation_stages(HighSchool{i});
end



end
