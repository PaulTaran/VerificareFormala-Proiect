function res = testLong_nonlinearSys_reach_output
% testLong_nonlinearSys_reach_output - tests if output equation works
%
% Syntax:  
%    res = testLong_nonlinearSys_reach_output
%
% Inputs:
%    -
%
% Outputs:
%    res - true/false
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Mark Wetzlinger
% Written:      19-November-2022
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% assume satisfaction
res = true;

% model parameters
params.tFinal = 0.1;
params.R0 = zonotope(ones(2,1),0.05*eye(2));
params.U = zonotope(0,0.01);

% reachability settings
options.timeStep = 0.01;
options.taylorTerms = 4;
options.zonotopeOrder = 30;
options.alg = 'lin';
options.tensorOrder = 2;
options.tensorOrderOutput = 2;

% dynamic equation
f = @(x,u) [x(1)^2 - x(2); x(2) - u(1)];
% linear output equation
g_lin = @(x,u) x(1) + x(2);
% quadratic output equation
g_quad = @(x,u) x(1) + x(2)^2;
% cubic output equation
g_cub = @(x,u) x(1) + x(2)^3;

% instantiate nonlinearSys objects
sys1 = nonlinearSys('sys1',f,g_lin);
sys2 = nonlinearSys('sys2',f,g_quad);
sys3 = nonlinearSys('sys3',f,g_cub);

% reachability analysis
reach(sys1,params,options);
reach(sys2,params,options);
options.tensorOrderOutput = 3;
reach(sys3,params,options);

%------------- END OF CODE --------------
