function Param = SetUpACASXu1AgentVerif

% Predefined Set Up for ACASXu Verification model.
% 
% 
% SETTINGS
%
% numagents: number of agents in the system
% plantDim: dimension of the state of the physical component of the system
% geometry: class with the method used to represent the set of states
% dynamics: plant dynamics
% method: reach method used by the neural network
% reachStep: time step for the analysis of the dynamics
% controlPeriod: execution period of the controllers
% outputMat: observer matrix
% NNfiles: directory of NN path files
% NNformat: class that defining correct format for NN
% NNreachMethod: class that contains only reachability analysis method
% commands: list of possible outputs
% pre: preprocessing func (splits interval if needed)
% norm: normalization function
% scale_mean: mean values of the inputs of the NNs (for normalization purpose)
% scale_range: range values of the inputs of the NNs (for normalization
% purpose)
% lambda: function applied on the output of the NNs, for deciding which
% command applying
% stopfcn: function that returns True if we reach the stopping criteria
% isSafefcn: function that returns True if we reach a safe scenario
% plotResults: function that plots the results of the reachability analysis

if ismac
    % Code to run on Mac platform
elseif isunix
    addpath('Models/ACASXu/');
    addpath('Models/ACASXu/nnv_format');
elseif ispc
    addpath('Models\ACASXu\');
    addpath('Models\ACASXu\nnv_format');
else
    disp('Platform not supported')
end

Param.numagents = 1;
Param.plantDim = 8;
Param.geometry = @Star;
Param.dynamics = @ACASXuVerifModel1Agent;
Param.method = 'approx-star';
Param.reachStep = 0.1;
Param.controlPeriod = 1;
Param.outputMat = eye(8);  % The observer --> selects the variables of interest: rho, theta, psi, vown, vint
Param.NNfiles = {ACASXuVerifNeuralNetworks};
Param.NNformat = @FFNNS;
Param.NNreachMethod = @LayerS;
Param.commands = ACASXuCommands;
Param.pre = @ACASXuVerifPreProcessing;
Param.norm = @Normalize;
Param.scale_mean = {[19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600; ...
                     19791.0910000000,0,0,650,600; 19791.0910000000,0,0,650,600]};
Param.scale_range = {[60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200; ...
                      60261,6.28318530718000,6.28318530718000,1100,1200]};
Param.lambda = {@ArgMinVerif}; 
Param.stopfcn = @ACASXuVerifStoppingCriteria;
Param.isSafefcn = @ACASXuVerifSafetyness;
Param.plotResults = @ACASXuPlot;

end