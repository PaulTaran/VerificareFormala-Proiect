function reach_random_neuralode_XXL()

    % Create a random and example of a Neural ODE
    rng(0);
    
    % Create random weight variables
    states = 5;
    input = 4;
    output = 4;
    h = 10;
    w1 = randn(input,states)'; b1 = randn(states,1);     % layer 1
    w21 = randn(h,states); b21 = randn(h,1);             % layer 2.1
    w22 = randn(states,h); b22 = randn(states,1);        % layer 2.2
    w3 = randn(states,states)'; b3 = randn(states,1);    % layer 3
    w4 = randn(states,states); b4 = randn(states,1);     % layer 4
    w5 = randn(states,output)'; b5 = randn(output,1);    % layer 5
    
    %% Create NeuralODE 
    layer1 = FullyConnectedLayer(w1,b1);
    layer1a = TanhLayer;
    layer3 = FullyConnectedLayer(w3,b3);
    layer3a = TanhLayer;
    layer5 = FullyConnectedLayer(w5,b5);
    layer5a = TanhLayer;
    
    cP1 = 0.1; % tf simulation
    reachStep1 = 0.005; % reach step
    C1 = eye(states);
    odeblock1 = NonLinearODE(states,1,@dyn1,reachStep1,cP1,C1); % Nonlinear ODE
    odeblock1.options.tensorOrder = 2;
    layer2 = ODEblockLayer(odeblock1,cP1,reachStep1,false);
    cP2 = 1; % tf simulation
    reachStep2 = 0.01; % reach step
    C2 = eye(states);
    odeblock2 = NonLinearODE(states,1,@dyn2,reachStep2,cP2,C2);
    odeblock2.options.tensorOrder = 2;
    layer4 = ODEblockLayer(odeblock2,cP1,reachStep1,true);
    neuralLayers = {layer1,layer1a,layer2,layer3,layer3a,layer4,layer5,layer5a};
    neuralode = NN(neuralLayers);
    
    % Input
    x0 = rand(input,1); 
    unc = 0.01;
    lb = x0-unc;
    ub = x0+unc;
    R0 = Star(lb,ub);
    
    % Reachability
    R = neuralode.reach(R0); % Reachability
    toc(t); 
    
    
    %% Dynamical functions

    function dx = dyn1(x,t)
        dx1 = tanh(w21*x+b21);
        dx = tanh(w22*dx1+b22);
    end
    
    function dx = dyn2(x,t)
        dx = tanh(w4*x+b4);
    end

end