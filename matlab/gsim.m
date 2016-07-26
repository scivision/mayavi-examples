function [Ne3m,Ne2m,Ne1,x,z] = gsim()
%% 1-D simulation
Z0 = 400;
H0 = 50;
N0 = 1e12;
dz = 20;
z = 100:dz:1000;

z1=(z-Z0)/H0;

Ne(:,1) = N0*exp(0.5*(1-z1-exp(-z1)));


% plot 1-D result
figure(1),clf(1)
plot(Ne,z)
xlabel('Ne')
ylabel('z')
title('Chapman vector')

%% 2-D from 1-D

dx = 0.5;
x = 0:dx:300;
nx = length(x);

Ne2 = repmat(Ne,[1 nx]);

%plot 2-D result
figure(2),clf(2)
imagesc(x,z,Ne2)
set(gca,'ydir','normal')
hc = colorbar;
ylabel(hc,'Ne')
xlabel('x')
ylabel('z')
title('unmodulated 2-D')

%% modulate 2-D
Mx = 0.5*cos(2*pi*1/75*x) + 1; % you don't want cos^2, but I did it here just to keep M everywhere positive
Ne2m = bsxfun(@times,Ne2,Mx);
%plot modulation
figure(10),clf(10)
plot(x,Mx)
xlabel('x')
ylabel('M_x')
title('modulation M_x')

% plot modulated 2-D result
figure(3),clf(3)
imagesc(x,z,Ne2m)
set(gca,'ydir','normal')
xlabel('x')
ylabel('z')
hc = colorbar;
ylabel(hc,'Ne')
title('modulated 2-D')


%% 3-D
dy = 0.5;
y = 0:dy:400;
ny = length(y);
My(:,1) = 0.5*cos(2*pi*1/35*y) + 1; % you don't want cos^2, but I did it here just to keep M everywhere positive

Ne1(1,1,:) = N0*exp(0.5*(1-z1-exp(-z1)));
Ne3 = repmat(Ne1,[ny nx 1]);

Ne3m = bsxfun(@times,Ne3,Mx);
Ne3m = bsxfun(@times,Ne3m,My);

%plot
figure(5),clf(5)
hs = slice(x,y,z,Ne3m,17.5,37.5,[150,400]);
set(hs,'EdgeColor','none')
xlabel('x')
ylabel('y')
zlabel('z')
hc = colorbar;
ylabel(hc,'Ne')
title('Ne(x,y,z)')

figure(11),clf(11)
plot(y,My)
xlabel('y')
ylabel('M_y')
title('modulation M_y')
%%
if nargout==0, clear, end
end %function
