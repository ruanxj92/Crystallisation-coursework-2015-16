function T_Nat=TNaturalCooling(t,endTime)
%Nature cooling profile to calculate the temperature at given time (in minute)within
%the possible time.
if (t>=0)&&(t<=endTime)
T_Nat=21+20.*exp(-0.02*t);
else
    error('Error. /nInput time beyond batch time!')
end
end