% System model
% x1 = lead_car position
% x2 = lead_car velocity
% x3 = lead_car internal state

% x4 = ego_car position
% x5 = ego_car velocity
% x6 = ego_car internal state

% lead_car dynamics
%dx(1,1)=x(2);
%dx(2,1) = x(3);
%dx(3,1) = -2 * x(3) + 2 * a_lead - mu*x(2)^2;

% ego car dynamics
%dx(4,1)= x(5); 
%dx(5,1) = x(6);
%dx(6,1) = -2 * x(6) + 2 * a_ego - mu*x(5)^2;


% let x7 = -2*x(3) + 2 * a_lead -> x7(0) = -2*x(3)(0) + 2*alead
% -> dx7 = -2dx3


A = [0 1 0 0 0 0 0; 0 0 1 0 0 0 0; 0 0 0 0 0 0 1; 0 0 0 0 1 0 0; 0 0 0 0 0 1 0; 0 0 0 0 0 -2 0; 0 0 -2 0 0 0 0];
B = [0; 0; 0; 0; 0; 2; 0];
C = [1 0 0 -1 0 0 0; 0 1 0 0 -1 0 0; 0 0 0 0 1 0 0];  % feedback relative distance, relative velocity, longitudinal velocity
D = [0; 0; 0]; 

plant = LinearODE(A, B, C, D); % continuous plant model

plantd = plant.c2d(0.1); % discrete plant model

% the neural network provides a_ego control input to the plant
% a_lead = -2 


% Controller
load('../controller_3_20.mat');

n = length(weights);
Layers = {};
for i=1:n - 1
    L = LayerS(weights{1, i}, bias{i, 1}, 'poslin');
    Layers{i} = L;
end
Layers{n} = LayerS(weights{1, n}, bias{n, 1}, 'purelin');
Controller = NN(Layers); % feedforward neural network controller
Controller.InputSize = 5;
Controller.OutputSize = 1;


% NNCS 

ncs = DLinearNNCS(Controller, plantd); % a discrete linear neural network control system

