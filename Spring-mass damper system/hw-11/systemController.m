classdef systemController
    properties
        m
        b
        k
        K
        Kr
        limit
        Ts
        
    end
    methods
        function self = systemController(p)
        % specify gains
        self.m = p.m;
        self.b = p.b;  
        self.k = p.k;
        self.K= p.K;
        self.Kr = p.Kr;
        self.limit= p.force_max;
        self.Ts = p.Ts;
        end
        
        function force = update(self,z_r, y)
            z=y(1);
            %feedback liinearized force
            force_f1=self.k*z;
            force_t=self.K*y+self.Kr*z_r;
            force=self.saturate(force_f1 + force_t);
        end
        function out = saturate(self,u)
            if abs(u)> self.limit
                u=self.limit*sign(u);
            end
    out=u;
        end
    end
end

