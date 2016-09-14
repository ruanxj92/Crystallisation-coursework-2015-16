function [ nonLinInEqConstr, nonLinEqConstr ] =nonLinConstraint(design_var, other_inputs )
%Non-linear constraint function 
% must output two arrays which the optimiser will ensure satisfy the
% conditions
% nonLinInEqConstr<0
% nonLinEqConst=0
%
%inputs: 
%design_var: the design variables must be supplied as an input array even if they
%are not used directly in the constraints 

% to access a value which has been stored in the "base" workspace 
%(e.g. something calculated in the objective function)

varName=evalin('base','storedName'); 

nonLinInEqConstr=;
nonLinEqConstr=;

end