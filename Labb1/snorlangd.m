function len = snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF)



% definiera unika F och DF för varje fall
Fcb = @(x) F(x,rc,rb,c,b);
DFcb = @(x) DF(x,c,b);
Fab = @(x) F(x,ra,rb,a,b);
DFab = @(x) DF(x,a,b);
Fac = @(x) F(x,ra,rc,a,c);
DFac = @(x) DF(x,a,c);

% beräkna rötterna
% FIXA: newtons metod konvergerade inte mot denna rot, använde en annan
% istället
startc = goofy_method(Fcb,xcb,0.6,0.8,100);
rcb = newton_multivariable(Fcb,DFcb,startc,300,0.5,false,10e-11);
rab = newton_multivariable(Fab,DFab,xab,300,0.2,false,10e-11);
rac = newton_multivariable(Fac,DFac,xac,300,0.2,false,10e-11);

ang = @(midpoint,a,b) acos(((a-midpoint)'*(b-midpoint))/(norm(a-midpoint)*norm(b-midpoint)));

arc_a = ang(a,rac(1:2),rab(1:2)) * ra;
arc_b = ang(b,rcb(3:4),rab(3:4)) * rb;
arc_c = ang(c,rcb(1:2),rac(3:4)) * rc;

len = norm(rac) + norm(rab) + norm(rcb) + arc_a + arc_b + arc_c;

end