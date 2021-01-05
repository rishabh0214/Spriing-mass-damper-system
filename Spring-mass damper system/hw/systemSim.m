start = 0;    % start time
tend = 100;     % end time
t_plot = 0.1;   % sample rate for plotter and animation
Tstep =0.01;       % sample rate for dynamics and controller

% instantiate system, controller, and reference classes
system = systemDynamics(Tstep);
 
ref = signalGenerator(0.5, 0.05);
disturbance = signalGenerator(1.0, 0.0); 
siggen = signalGenerator(0.01);

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
        r = ref.square(t);      % assign reference  
        d = disturbance.step(t);      % simulate input disturbance
        n = siggen.random(t);          % simulate noise
        y = system.update(d);       % Propagate the dynamics
        t = t + Tstep;                   % advance time by Ts
    end
    % update animation and data plots
    animation.update(system.state);
    dataPlot.update(t, r, system.state);
   
    frame=getframe(gcf);
    drawnow();
    writeVideo(video,frame)
end 
close(video);