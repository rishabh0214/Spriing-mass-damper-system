parameter;


% instantiate system, controller, and reference classes
system = systemDynamics(p);
controller=systemController(p); 
ref = signalGenerator(0.5, 0.05);
disturbance = signalGenerator(0.25,0.0);
noise= signalGenerator(0.01);


% instantiate the data plots and animation
dataPlot = dataPlotter(p); 
animation = systemAnimation();


% main simulation loop
t = p.start;      % time starts at t_start  
y = system.h();   % system output at start of simulation
video=VideoWriter('animation.avi');
video.FrameRate=120;
open(video);
while t < p.tend
    
    % set time for next plot
    t_next_plot = t + p.t_plot;
    % updates control and dynamics at faster simulation rate
    while t < t_next_plot
        r = ref.square(t);            % assign reference  
        d = disturbance.step(t);      % simulate input disturbance
        n = 0.0;                      % simulate noise
        x=system.state;
        u=controller.update(r,x);
        y = system.update(u+d);       % Propagate the dynamics
        t = t + p.Ts;                   % advance time by Ts
    end
    % update animation and data plots
    animation.update(system.state);
    dataPlot.update(t, r, system.state,u);
   
    frame=getframe(gcf);
    drawnow();
    writeVideo(video,frame)
end 
close(video);