%set the process parameters
endTime = 300; %length of time for crystallisation 
Ntimes=3000; %number of discrete time intervals used (Ntimes+1 values of T)

startT=41+273;%starting temperature /K
endT=21+273; %ending temperature of initial linear estimated profile /K

minT=21+273;
maxT=41.11+273;
Trange=[minT maxT];

minCoolRate=0; %minimum cooling rate 
maxCoolRate=4; %maximum cooling rate 

%the CSD (Cristal Size Distribution) and the concentration of solution
C0=0.0253;%the initial concentration /g per g solvent
CSD=zeros(2,Ntimes+1);
%CSD=[number;...
%     size;]

TSet0=linspace(startT,endT,Ntimes+1)';%Set up the initial discrete time and temperature values
timeSet=linspace(0,endTime,Ntimes+1)';%based on a linearly decreasing temperature profile 

other_inputs=struct(...
    'k_v',0.2...%volumetric shape factor
    ,'rho',1.296...%the density of crystal
    ,'CSD',CSD...%the CSD (Cristal Size Distribution) 
    ,'C0',C0...
    );

%lower and upper bounds are min and max temperatues
%but have to be arrays of the same shape as TSet0

lowerBounds=ones(size(TSet0))*minT;
upperBounds=ones(size(TSet0))*maxT;

minTSet=ones(size(TSet0))*minT;
maxTSet=ones(size(TSet0))*maxT;
%force the start and end temperatures to stay at settings
minTSet(1)=startT;
maxTSet(1)=startT;
minTSet(end)=endT;
maxTSet(end)=endT;

% Linear constraint on cooling rate 
% constraint is defined by arrays A and B such that
% A*design_var<B
% Cooling rate in each time step is T(n+1)-T(n)/(timeinterval) 
% so T(n+1)-T(n) is used for A, with delT*coolingRate used as B
%coolRatedelT=eye(Ntimes,Ntimes+1)-[zeros(Ntimes,1) eye(Ntimes,Ntimes)]; 
%delT=(endTime/Ntimes); %in same units as the endTime

%coolRateMatrix=[coolRatedelT;-coolRatedelT];
%coolRateLimits=[maxCoolRate*delT*ones(Ntimes,1);minCoolRate*delT*ones(Ntimes,1)];

%these are options for the optimiser
OPTIONS = optimset('TolCon',1e-3,'TolFun',1e-3,'TolX',1e-3,...
      'Display','iter','MaxIter',100,'Diagnostics','on',...
      'algorithm', 'active-set');

%set initial value of the design variables
design_var0=TSet0;
%optimise by varying the design variables
%the optimum value of the design variables is "opt_design_var"
%syntax :x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
outputs=process_model(timeSet,TSet0,other_inputs)
return
[opt_design_var,~] = fmincon(@(design_var) obj_function(design_var,timeSet,other_inputs),...
    design_var0,[],[],...
    [],[],lowerBounds,upperBounds,...
    @(design_var) nonLinConstraint(design_var,other_inputs),...
    OPTIONS);
%use the process model to simulate the process with the optimised design
%variables, and with the initial linear cooling profile