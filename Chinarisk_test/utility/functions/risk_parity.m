function [x,fval,exitflag,output,solutions] = risk_parity(Sigma,w,x0,Aineq,bineq,Aeq,beq,lb,ub)

   %   https://en.wikipedia.org/wiki/Risk_parity
   %   step1 : marginal risk contribution   sigma(i) = ...
   %           hence  sigma  = sum( sigma(i))
   %   step2: (sigma(1),sigma(2),...,sigma(n) =  (w1,w2,....,wn)   = w
   %   hence the opimization becomes sigma(i) = wi*sigma
   %   or by solving the minimization problem
   %       sigma(i) = wi*sigma
   %      x_i*(Sigma*x)_i /sqrt(x'*Sigma*x) = wi * sqrt(x'*Sigma*x)
   %      x_i*(Sigma*x)_i  = wi * x'*Sigma*x

   
%     A test example
%     Sigma = cov(rand(3));   z*z
%     z = size(Sigma,1);
%     w = 1/z*ones(z,1);      z*1
%     x0 = 1/z*ones(z,1);     z*1
%     Aineq = [];
%     bineq = [];
%     Aeq = ones(1,z);       1*z
%     beq = 1;               
%     lb = zeros(z,1);       z*1
%     ub = 2*ones(z,1);      z*1


   % f = @(x)sum(((Sigma*x).*x - x'*Sigma*x*w).*((Sigma*x).*x - x'*Sigma*x*w));
     f  = @(x)rp_obj(x,Sigma);
   
    opts = optimoptions(@fmincon,'Algorithm','interior-point','Display','off');
    problem = createOptimProblem('fmincon','objective', f,...
                                 'x0',x0,...
                                 'Aineq',Aineq,...
                                 'bineq',bineq,...
                                 'Aeq',Aeq,...
                                 'beq',beq,...
                                 'lb',lb,...
                                 'ub',ub,...
                                 'options',opts);
    gs = GlobalSearch('XTolerance',1e-10,'NumTrialPoints',1e3);
    [x,fval,exitflag,output,solutions] = run(gs,problem);
   % exitflag
    

end

