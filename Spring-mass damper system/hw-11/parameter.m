%paraameters of the controller

p.m=4.822; %kg
p.k=2.831; %N/m
p.b=0.4991; %Ns/m

%simulation parameter
p.start = 0;    % start time
p.tend = 100;     % end time
p.t_plot = 0.1;   % sample rate for plotter and animation
p.Ts =0.01;       % sample rate for dynamics and controller

%  tuning parameters
%tr = 1.25; % previous tuned parameter
tr = 0.37;  % tuned to get fastest possible rise time before saturation.
zeta = 0.707;
p.ki = 0.1;  % integrator gain

% desired closed loop polynomial
wn = 2.2/tr;
Delta_cl_d = [1, 2*zeta*wn, wn^2];

% compute PD gains
p.kp = (Delta_cl_d(3)*p.m)-p.k;
p.kd = (Delta_cl_d(2)*p.m)-p.b;


A = [0, 1;-p.k/p.m, -p.b/p.m;];
B = [0;1.0/p.m ];
C = [1, 0;];

% gains for pole locations
des_char_poly = [1,2*zeta*wn,wn^2];
des_poles = roots(des_char_poly);

% is the system controllable?
if rank(ctrb(A,B))~=2 
    disp('System Not Controllable'); 
else
    p.K = place(A,B,des_poles); 
    p.Kr = -1/(C*inv(A-B*p.K)*B);
end

% dirty derivative parameters
p.sigma = 0.05; % cutoff freq for dirty derivative

% control saturation limits
p.force_max = 6; 

fprintf('\t kp: %f\n', p.kp)
fprintf('\t ki: %f\n', p.ki)
fprintf('\t kd: %f\n', p.kd)
fprintf('\t K: [%f, %f]\n', p.K(1), p.K(2))
fprintf('\t Kr: %f\n', p.Kr)


