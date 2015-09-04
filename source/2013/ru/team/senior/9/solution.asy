import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), C = (5,0), B = (1,4),
    ABC = triangle(A, B, C),
    M = midpoint(ABC.AC),
    circumABC = circumcircle(ABC), O = circumABC.C,
    exA = excircle(ABC.BC), exC = excircle(ABC.AB),
    I_A = exA.C, I_C = exC.C, ell = line(I_A, I_C),
    Ap = projection(A, C) * I_A, Cp = projection(A, C) * I_C,
    App = projection(A, B) * I_A, Cpp = projection(B, C) * I_C,
    L = O + circumABC.r * unit(O - M);

pen gray = gray(0.7);

draw(circumABC, gray+1);
draw(ell, gray+1);

draw(ABC, linewidth(1));
clipdraw(exA);
clipdraw(exC);
draw(line(A, Cp, extendA=false));
draw(line(C, Ap, extendA=false));
draw(line(B, Cpp, extendA=false));
draw(line(B, App, extendA=false));
draw(I_A--Ap ^^ I_C--Cp);
draw(B--O ^^ L--O ^^ M--O, dashed);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, 1.4(N+NNW)));
dot(Label("$C$", C, SE));
dot(Label("$M$", M, S));
dot(Label("$L$", L, N));
dot(Label("$I_A$", I_A, -ell.v));
dot(Label("$I_C$", I_C, -ell.v));
dot(Label("$A'$", Ap, SSE));
dot(Label("$C'$", Cp, SSW));
dot(Label("$O$", O, WSW));

dot(O);

dot(I_A + exA.r * unit(B-C) * dir(10), invisible);
dot(I_C + exC.r * unit(B-A) / dir(10), invisible);

dot(I_A + exA.r * unit(Ap-I_A) * dir(20), invisible);
dot(I_C + exC.r * unit(Cp-I_C) / dir(20), invisible);

