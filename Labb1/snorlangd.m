function len = snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF)



% definiera unika F och DF för varje fall
Fcb = @(x) F(x,rc,rb,c,b);
DFbc = @(x) DF(x,b,c);
Fab = @(x) F(x,ra,rb,a,b);
DFab = @(x) DF(x,a,b);
Fac = @(x) F(x,ra,rc,a,c);
DFac = @(x) DF(x,a,c);

% beräkna rötterna
% FIXA: newtons metod konvergerade inte mot denna rot, använde en annan
% istället
startc = goofy_method(Fcb,xcb,0.6,0.8,100);
rbc = newton_multivariable(Fcb,DFbc,startc,300,0.5,false,10e-11,false,false);
rab = newton_multivariable(Fab,DFab,xab,300,0.2,false,10e-11,false,false);
rac = newton_multivariable(Fac,DFac,xac,300,0.2,false,10e-11,false,false);

ang = @(midpoint,a,b) acos(((a-midpoint)'*(b-midpoint))/(norm(a-midpoint)*norm(b-midpoint)));

arc_a = ang(a,rac(1:2),rab(1:2)) * ra;
arc_b = ang(b,rbc(3:4),rab(3:4)) * rb;
arc_c = ang(c,rbc(1:2),rac(3:4)) * rc;

len = norm(rac(1:2)-rac(3:4)) + norm(rab(1:2)-rab(3:4)) + norm(rbc(1:2)-rbc(3:4)) + arc_a + arc_b + arc_c;

end