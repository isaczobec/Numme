function val = fpi_method(g,x0,n,stop_error_difference)
arguments
    g,
    x0,
    n,
    stop_error_difference = 0
end
% försöker hitta en fixpunkt r till g s.a g(r) = r givet ett startvärde x0 och
% antal iterationer n


currentVal = x0;

for i = 1:n
    xn1 = g(currentVal);
    if abs(currentVal-xn1) < stop_error_difference
        disp(['nådde begärd skillnad i error efter ',num2str(i),' iterationer'])
        currentVal = xn1;
        break
    end
    currentVal = xn1;
end

val = currentVal;

end