fprintf('\n\n=============================LOAD VGG16 ======================\n');

% Load the trained model 
net = vgg16();

fprintf('\n\n======================== PARSING VGG16 =======================\n');
nnvNet = matlab2nnv(net);


fprintf('\n\n=========CONSTRUCT INPUT SET (AN IMAGESTAR SET) =============\n');
load image_data.mat;
V(:,:,:,1) = double(ori_image);
V(:,:,:,2) = double(dif_image);

%l = [0.5 0.8 0.95 0.97 0.98 0.98999];
l = 0.5;
delta = 0.0000001;
n = length(l);

pred_lb = zeros(n, 1);
pred_ub = zeros(n, 1);
robust_exact = zeros(n, 1);
robust_approx = zeros(n, 1);
VT_exact = zeros(n, 1);
VT_approx = zeros(n, 1);

correct_id = 946; % id for bell pepper
for i=1:n
    pred_lb(i) = l(i);
    pred_ub(i) = l(i) + delta;
    
    C = [1;-1];   % pred_lb % <= alpha <= pred_ub percentage of FGSM attack
    d = [pred_ub(i); -pred_lb(i)]; 
    IS = ImageStar(V, C, d, pred_lb(i), pred_ub(i));
    
    fprintf('\n\n=================== VERIFYING ROBUSTNESS FOR l = %.5f, delta = %.8f ====================\n', l(i), delta);
    % exact-star
    reachOptions = struct;
    reachOptions.reachMethod = 'exact-star';
    t = tic;
    robust_exact(i) = nnvNet.verify_robustness(IS, reachOptions, correct_id);
    VT_exact(i) = toc(t);
    % approx-star
    reachOptions = struct;
    reachOptions.reachMethod = 'approx-star';
    t = tic; 
    robust_approx(i) = nnvNet.verify_robustness(IS, reachOptions, correct_id);
    VT_approx(i) = toc(t);
end


fprintf('\n\n===================================VERIFICATION RESULTS===================================\n\n');

fprintf('\n l                    delta               Exact Analysis          Approximate Analysis');
fprintf('\n                                         Robust        VT           Robust         VT');
for i=1:n
    fprintf('\n %.6f          %.8f              %d        %.5f           %d         %.5f', l(i), delta, robust_exact(i), VT_exact(i), robust_approx(i), VT_approx(i));
end

% save verificationResult_1e_07.mat l delta robust_exact VT_exact robust_approx VT_approx;

