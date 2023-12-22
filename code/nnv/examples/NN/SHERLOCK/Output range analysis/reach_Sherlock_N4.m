% Load neural network information
load('../models/neural_network_information_4.mat')

% Create NNV neural network (NN)
n = length(W);
Layers = cell(n,1);
for i=1:n
    try
        L = LayerS(W{i}, b{i}, 'poslin');
    catch
        L = LayerS(W{i}', b{i}, 'poslin');
    end
    Layers{i} = L;
end
Layers{end}.f = 'purelin';
F = NN(Layers); % neural network

% Define input set
lb = [0; 0]; % lower_bound
ub = [10; 10]; % uper_bound
I = Star(lb, ub); % input set

%% Reachability analysis

% Define reachability options
reachOptions = struct;
% reachOptions.reachMethod = 'exact-star';
% reachOptions.numCores = 4;
reachOptions.reachMethod = 'approx-star';

% Compute reachable set
t = tic;
R1 = F.reach(I, reachOptions);
reach_time = toc(t);

