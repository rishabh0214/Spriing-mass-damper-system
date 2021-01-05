start = 0;    % start time
tend = 100;     % end time
t_plot = 0.1;   % sample rate for plotter and animation
Tstep =0.01;       % sample rate for dynamics and controller

% instantiate system, controller, and reference classes
system = systemDynamics();
controller=systemController(); 
ref = signalGenerator(0.5, 0.05);
disturbance = signalGenerator(0.0); 


% instantiate the data plots and animation
dataPlot = dataPlotter(); 
animation = systemAnimation();


% main simulation loop
t = start;      % time starts at t_start  
y = system.h();   % system output at start of simulation
video=VideoWriter('animation.avi');
video.FrameRate=120;
open(video);
while t < tend
    
    % set time for next plot
    t_next_plot = t + t_plot;
    % updates control and dynamics at faster simulation rate
    while t < t_next_plot
        r = ref.square(t);            % assign reference  
        d = disturbance.step(t);      % simulate input disturbance
        n = 0.0;                      % simulate noise
        x=system.state;
        u=controller.update(r,x);
        y = system.update(u+d);       % Propagate the dynamics
        t = t + Tstep;                   % advance time by Ts
    end
    % update animation and data plots
    animation.update(system.state);
    dataPlot.update(t, r, system.state,u);
   
    frame=getframe(gcf);
    drawnow();
    writeVideo(video,frame)
end 
close(video);