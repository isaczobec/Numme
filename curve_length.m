function len = curve_length(paraFuncX,paraFuncY,tStart,tEnd,numPoints)
%curve_length Summary of this function goes here
%   Detailed explanation goes here


tS = linspace(tStart,tEnd,numPoints);

points = [paraFuncX(tS);paraFuncY(tS)]';

startPoints = points(1:end-1,1:2);
endPoints = points(2:end,1:2);

diffs = endPoints - startPoints;

lens = sqrt(diffs(1:end,1).^2 + diffs(1:end,2).^2);

len = sum(lens);


end

