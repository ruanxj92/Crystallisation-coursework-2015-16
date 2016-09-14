function [outputs] = process_model( timeSet,TSet,other_inputs )
%The process model used by the optimisation
%For crystallisation this is the ordinary differential equation solution 
%based on the rates of change of the moments of the crystal size
%distribution
N=500;
timeRange=linspace(0,timeSet(end),N);

CSD0=[zeros(4,1);...%mu0; mu1; mu2; mu3, 
    other_inputs.C0];%initial concentration
[time,CSD]=ode45(@(t,CSD) dcrystCSDdt(t,CSD,timeSet,TSet,other_inputs),timeRange,CSD0);
outputs=[time,CSD];

dt=time(2)-time(1);%the length of each piece of time 
mu0=CSD(:,1);%total number
mu1=CSD(:,2);%total length
mu2=CSD(:,3);%total area
mu3=CSD(:,3);%total volume
C=CSD(:,5);%concnetration


fn=(mu0-[0;mu0(1:end-1)])./(mu0+eps);%
%G=;


outputs=struct('time',time,'CSD',CSD);
end