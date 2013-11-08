import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    the_circle = circle((point)(0,0), 1),
    O = the_circle.C, E = (0,1), X = (0,-1),
    k = 1.45, x = k^2 - 1 - sqrt(k^4 - 2 k^2),
    beta = k / (x + 1), alpha = k - beta,
    D = (-alpha, 1), C = (beta, 1),
    A = (-1/alpha, -1), B = (1/beta, -1),
    M = (A + B) / 2, F = 2 O - M,
    T = extension(A, D, B, C);

clipdraw(the_circle, gray(0.5)+1);

draw(A--B--C--D--cycle, linewidth(1));
draw(D--T--C, dashed);
draw(M--F);

mark(A--M, 1);
mark(M--B, 1);

mark(D--E, 2);
mark(F--C, 2);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NE));
dot(Label("$D$", D, NNW));

dot(Label("$E$", E, N));
dot(Label("$M$", M, SSW));
dot(Label("$O$", O, ESE));
dot(Label("$F$", F, NNE));

dot(Label("$T$", T, NNE));
dot(Label("$X$", X, S));

