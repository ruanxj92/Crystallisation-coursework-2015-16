function objective = obj_function(design_var,timeSet, other_inputs)
% the objective function for the optimisation 
% Use the process model to calculate the crystal size distribution moments
% and the solution concentration as a function of time
% Outputs a single value which will be minimised by the optimiser by varying
% the design variables which are input as an array design_var
% timeSet is the array of times at which the design variables are specified
% other_inputs are inputs which are used by the process model 
TSet=other_inputs.TSet;
outputs=process_model(timeSet,TSet,other_inputs);

if false
    objective =std(); %narrowest crystal size distribution 
else
    objective =outputs; %largest mean crystal size
end


% this code saves the value of varName to the base workspace so it can be 
% used by the nonlinear constraint function 
% In the workspace it will be called "storedName"
assignin('base','storedName',varName); 
end