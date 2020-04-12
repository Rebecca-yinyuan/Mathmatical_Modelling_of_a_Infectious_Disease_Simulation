function infectionTimesAnalysis()


clc


% Import data from text files: 
% The textfile has 10 data set with the following parameter configuration: 
%
% Total # people = 300;
% # handshakes = 10;
% Infectious period = 5;
% Initial # infectives = 1.

contents = fileread('InfectiousTimeLargeUni.txt');
contents = strsplit(contents, 'game');
InfectionTimeLargeUni = ...
    cellfun(@(c) sscanf(c, '%f', [3 Inf])', contents(2:end), 'UniformOutput', false);
data = InfectionTimeLargeUni{1};


num_handshake = 5;
max_timesteps_in_I = num_handshake + 1;


% Plot some Graphs: 
% TimestepVSInfectedTime(data);
histogram_for_each_numTimestep(data, max_timesteps_in_I);   


end


function TimestepVSInfectedTime(data)

figure(250);

x = data( : , 3); % the time where the person became infected;
y = data( : , 2); % the number of timestep that person is in I;

plot(x, y, 'o', 'MarkerSize', 8);
xlabel('The Time Where They Became Infected');
ylabel('# of Timesteps the Infected Person is in I');
hold off

% This method does not work since if two points overlaping together,
% you will only get one point and you cannot tell any difference compared
% with the other points. 

end

function histogram_for_each_numTimestep(data, max_timesteps_in_I)

infected_time = data( : , 3); 
timesteps_in_I = data( : , 2); 
    
for i = 1 : max_timesteps_in_I
    
    array = zeros(length(infected_time), 1); % initialise the array. 
    array_length = 0;
    for  j = 1 : length(infected_time)
        
        if timesteps_in_I(j) == i
            array(j) = infected_time(j);
            array_length = array_length + 1; % This record the valid array length used for histogram. 
        end
        
    end
    
    histogram_X = zeros(array_length, 1); 
    histogram_index = 1;
    for k = 1 : length(infected_time)
        
        if array(k) ~= 0
            histogram_X(histogram_index) = array(k);
            histogram_index = histogram_index + 1;
        end
        
    end
    
    figure(i);
    histogram(histogram_X);
end    

end