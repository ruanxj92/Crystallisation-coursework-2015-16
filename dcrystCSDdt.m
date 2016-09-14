function [ dCSDdt ] = dcrystCSDdt( t,CSD,timeSet,TSet,other_inputs)
% function to calculate the rates of change (time derivatives)
%of the moments of the crystal size distribution (CSD) and the concentration of the
%solution according to a population-balance model
%
%the set of temperatures TSet is defined at particular discrete times 
%(stored in timeSet), and interpolated between these values
%
%Inputs:
%t=time
%CSD= the moments of the CSD and the concentration of solution
%other_inputs are parameters which are needed for the model

%interpolate to find the current temperature at time t
Tcurrent=interp1(timeSet,TSet,t); 

%calculate the derivatives of the moments of the crystal size distribution
%and the solution concentration
%the method of moment is used to do the simulation
%four lowest order momennts are simulated since many properties  of the CSD
%can be expressed as a function of theses moments.
mu0=CSD(1);
mu1=CSD(2);
mu2=CSD(3);

if (t-0)^2<1e-9
    C=other_inputs.C0;
else
    C=CSD(end);
end

C_sat=1.306639-9.05675e-3*Tcurrent+1.5846e-5*Tcurrent^2;
S=C-C_sat;
if S>0
    G=1.6*S^1.5;%growth rate
    B=7.9e19*S^6.3;%nucleation rate
else
    G=-1.6*S^1.5;%growth rate cm min-1
    B=0;%nucleartion rate min-1
end

dmiu0dt=B;%number min-1
dmiu1dt=G*mu0;%diameter cm min-1
dmiu2dt=2*G*mu1;%area cm^2 min-1
dmiu3dt=3*G*mu2;%volume cm^3 min-1
dCdt=-other_inputs.k_v.*other_inputs.rho.*dmiu3dt;

dCSDdt=[dmiu0dt;dmiu1dt;dmiu2dt;dmiu3dt;dCdt];
end