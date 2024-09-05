function val = fpi_method(g,x0,n)
% försöker hitta en fixpunkt r till g s.a g(r) = r givet ett startvärde x0 och
% antal iterationer n


currentVal = x0;

for i = 1:n
    currentVal = g(currentVal);
end

val = currentVal;

end