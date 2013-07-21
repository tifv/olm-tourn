import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;

var
    S = (0,0),
    A = dir(-150),
    B = A * dir(30), C = B * dir(30), D = C * dir(30), Ap = D * dir(30);

draw(S--A--B--C--D--Ap--cycle);
draw(S--B);
draw(S--C);
draw(S--D);
draw(A--Ap, dashed);

markangle(A, S, B, radius=mr);
markangle(B, S, C, L=scale(0.7) * "$30^\circ\!$", radius=1.2mr);
markangle(C, S, D, radius=mr);
markangle(D, S, Ap, radius=1.2mr);

dot(Label("$A$", A, unit(A) / dir(45)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));
dot(Label("$A'$", Ap, unit(Ap) * dir(45)));

dot(Label("$S$", S, unit(-A-Ap)));

label("$1$", (A+S)/2, unit(A-S) / I);
label("$1$", (Ap+S)/2, unit(Ap-S) * I);

