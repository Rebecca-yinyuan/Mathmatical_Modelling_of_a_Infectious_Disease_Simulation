function SEIR_data = SIR_2_SEIR(SIR_data)
% This function converts one set of SIR data to SEIR data. 


S_SEIR = SIR_data( : , 1);
R_SEIR = SIR_data( : , 3);

E_SEIR = zeros(length(S_SEIR), 1); % Initilize the 'E' array
num_initial_exposed = 1;
E_SEIR(1) = num_initial_exposed;

I_SEIR = zeros(length(S_SEIR), 1); % Initilize the 'I' array 

total_num_people = S_SEIR(1) + R_SEIR(1) + num_initial_exposed + 0;

% Find E in SEIR model:
for i = 2 : length(S_SEIR)
    E_SEIR(i) = S_SEIR(i - 1) - S_SEIR(i);
end

% Find I in SEIR model:
for i = 1 : length(S_SEIR)
    I_SEIR(i) = total_num_people - E_SEIR(i) - S_SEIR(i) - R_SEIR(i);
end

SEIR_data = [S_SEIR, E_SEIR, I_SEIR, R_SEIR];

end
