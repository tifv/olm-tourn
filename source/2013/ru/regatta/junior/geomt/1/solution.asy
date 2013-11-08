import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    the_circle = circle((point)(0,0), 1),
    alpha = 150, beta = 140, delta = alpha + beta - 180,
    A = dir(- 90 - delta), D = dir(- 90 + delta),
    B = A * dir(2*alpha), C = dir(70),
    M = (A + B) / 2, N = (C + D) / 2, P = (A + D) / 2;

clipdraw(the_circle, gray(0.5)+1);

draw(A--B--C--D--cycle, linewidth(1));
draw(P--M);
draw(N--P, dashed);

mark(A--M, 1);
mark(M--B, 1);

mark(C--N, 2);
mark(N--D, 2);

mark(A--P, 3);
mark(P--D, 3);

markangle(D, P, M, radius=0.7mr);
markangle(B, C, D, radius=0.4mr, n=2);

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));

dot(Label("$M$", M, 1.7 S));
label(Label("$N$", unit(N), unit(N)));
dot(Label("$P$", P, S));

dot(Label(scale(0.8) * "$?$", N, S));

