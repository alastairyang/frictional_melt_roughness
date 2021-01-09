function t = analyticalsol_time(param)
    Tf = param.Tf;
    thick = param.loc;
    alpha = param.alpha; % diffusivity
    k = param.k; % solid conductivity
    T0 = param.T0; % ambient temp
    shear = param.shear;
    v = param.v;
    q = shear*v;
    fcn = @(t) Tf-(T0+(2*q/k)*(sqrt(alpha*t/pi)*exp(-(thick^2)/(4*alpha*t))...
        -0.5*thick*erfc(thick/(2*sqrt(alpha*t)))));
    t = fzero(fcn,[1e-9,1]); % specify search range to avoid complex number
end
