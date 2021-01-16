clear all
close all
clc

%% loop
maxTime = 100;
m = 1;

r_sim = zeros(maxTime+1,1);
v_sim = zeros(maxTime+1,1);
o_sim = zeros(maxTime+1,1);

r = 0;
v = 0;
o = 0;
fi = 0.1;
for t = 1:maxTime
    % define a (=fnet)
    ddrPhi = 0; %0.01*r;
    fnet = (fi - ddrPhi);
    
    % update r
    rNext = r+v;
    
    % update v
    pd_f = makedist('Normal', 'mu', v+fnet/m, 'sigma', 0.1*abs(v));
    pcrash = min(max((abs(v)-10)/10,0),1);
    p = rand(1);
    vNext = 0;
    if(p > pcrash)
        vNext = random(pd_f);
    end
    
    % update o
    pd_h = makedist('Normal', 'mu', r, 'sigma', 0.5*abs(v));
    o = random(pd_h);
    
    r = rNext;
    v = vNext;
    
    % record values
    r_sim(t+1) = r;
    v_sim(t+1) = v;
    o_sim(t) = o;
end
pd_h = makedist('Normal', 'mu', r, 'sigma', 0.5*abs(v));
o = random(pd_h);
o_sim(maxTime+1) = o;

%% plot
figure(1)
hold on
plot(r_sim)
plot(o_sim)
grid on
title('Position and Observation')
xlabel('Time (s)')
ylabel('Position (m)')
legend('r','o')

figure(2)
plot(v_sim)
grid on
title('Velocity')
xlabel('Time (s)')
ylabel('Velocity (m/s)')
legend('v')




