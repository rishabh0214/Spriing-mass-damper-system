classdef dataPlotter < handle
    properties
        %initial conditions
        t_end=100;
        t_start=0;
        t_plot=0.1;
        % data histories
        time_history
        r_history 
        y_history
        ydot_history
        u_history
        index
        % figure handles
        r_handle 
        y_handle
        ydot_handle 
        u_handle
    end
    methods
        function self = dataPlotter()
           % Instantiate lists to hold the time and data histories
           self.time_history=NaN*ones(1,(self.t_end-self.t_start)/self.t_plot);
           self.r_history=NaN*ones(1,(self.t_end-self.t_start)/self.t_plot);
           self.y_history=NaN*ones(1,(self.t_end-self.t_start)/self.t_plot);
           self.ydot_history=NaN*ones(1,(self.t_end-self.t_start)/self.t_plot);
           self.u_history= NaN*ones(1,(self.t_end-self.t_start)/self.t_plot);
           self.index=1;
           % Create figure and axes handles
           figure(2), clf
           subplot(3,1,1)
                hold on
                self.r_handle=plot(self.time_history,self.r_history,'r');
                self.y_handle=plot(self.time_history,self.y_history,'b');
                ylabel('y')
                title('SYSTEM DATA')
           subplot(3,1,2)
                hold on
                self.ydot_handle = plot(self.time_history,self.ydot_history, 'b');
                ylabel('velocity')
           subplot(3,1,3)
                hold on
                self.u_handle=plot(self.time_history,self.u_history, 'b');    
                ylabel('input')
                 
        end
        
        function self=update(self, time, reference, states,control)
            % update the time history of all plot variables
            self.time_history(self.index) = time; 
            self.r_history(self.index) = reference; 
            self.y_history(self.index) = states(1);
            self.ydot_history(self.index) = states(2);
            self.u_history(self.index) = control;
            self.index = self.index + 1;
            % update the plots with associated histories
            set(self.r_handle,'Xdata', self.time_history,'Ydata', self.r_history)
            set(self.y_handle,'Xdata', self.time_history,'Ydata', self.y_history)
            set(self.ydot_handle,'Xdata', self.time_history,'Ydata', self.ydot_history)
            set(self.u_handle,'Xdata', self.time_history, 'Ydata', self.u_history)
        end
    end
end

                
                