function len = curve_length_seq(paraFuncX,paraFuncY,tStart,tEnd,numPoints)
%curve_length Summary of this function goes here
%   Detailed explanation goes here


tS = linspace(tStart,tEnd,numPoints);

currentX = paraFuncX(tS(1));
currentY = paraFuncY(tS(1));

sumLen = 0;

for i = tS
    nextX = paraFuncX(i);
    nextY = paraFuncY(i);

    l = sqrt((currentX - nextX)^2 + (currentY - nextY)^2);
    sumLen = sumLen + l;

    currentX = nextX;
    currentY = nextY;
end

len = sumLen;

end

