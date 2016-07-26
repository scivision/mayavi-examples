% Ne term using Chapman model

function [Ne] = chapman(z)
%% finds chapman model values of electron density
z0 = 400; % km
h0 = 50; %km
n0 = 10^12; % m^-3

z1 = (z-z0)./h0;

Ne = n0*exp(0.5*(1-z1-exp(-z1)));

end