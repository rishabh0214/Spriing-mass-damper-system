classdef systemController
    properties
        kp 
        kd 
        ki
        Ts 
        sigma
        limit
        k
        ctrl
    end
    methods
        function self = systemController()
        % specify gains
        self.kp = 3.00;
        self.kd = 6.94;  
        self.Ts =0.01;
        self.sigma=0.02;
        self.limit = 6.0;
        self.k=2.831;
        self.ki = 0.1;
        self.ctrl=PIDController(self.kp,self.ki,self.kd,self.limit,self.sigma,self.Ts);
        end
        
        function force = update(self,z_r, y)
            z=y(1);
            %feedback liinearized force
            force_f1=self.k*z;
            force_t=self.ctrl.PID(z_r,z,false);
            force=force_f1 + force_t;
        end
    end
end
