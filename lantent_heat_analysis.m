function [L,dL] = lantent_heat_analysis (m,varargin)
%%%
% This function is used to calculate Lantent Heat in UCL PHSA0008 t8
% experiment
% The equation used here is L = p / (dm/dt - dmbg/dt)
%
% Input
% m: is a n * 1  length array contains mass data from the balance
% t: is the time data with the same size of m that contains time
% imformation when the data is taken
% bg: is the background rate of change of mass in the lab
% dbg: is a 1*2 array contain the upper and lower boundary of background
% rate of change of mass in the lab [upper,lower]
% pw: is the power of heater in this experiment
% dpw: is a 1*2 array containing upper and lower boundary of the power of
% heater in this experiment [upper,lower]
% cil: is confidence interval level of the error(0.95 by defult)
%
% Output
% L: is the value of Lantent heat
% dL: is the error of L, with 95% confidence interval
%%%

p = inputParser;
addRequired(p, 'm', @isnumeric);  
addRequired(p, 't', @isnumeric);  
addRequired(p, 'pw', @isnumeric);   
addRequired(p, 'dpw', @isnumeric);  
addOptional(p, 'bg', 0.0412, @isnumeric); 
addOptional(p, 'dbg', [0.0426,0.0398], @isnumeric); 
addOptional(p, 'cil', 0.95, @isnumeric); 
parse(p, m, varargin{:});

m = p.Results.m;
t = p.Results.t;
pw = p.Results.pw;
dpw = p.Results.dpw;
bg = p.Results.bg;
dbg = p.Results.dbg;
cil = p.Results.cil;

fitting = fit(t,m,'poly1');
ci = confint(fitting,cil);

fitting.p1
L = pw / (abs(fitting.p1)-bg)
dL = [dpw(1) / (abs(ci(2,1))-dbg(2)),dpw(2) / (abs(ci(1,1))-dbg(1))]
end