import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    A = dir(195), B = dir(80), C = dir(-40), D = dir(-85),
    alpha = (abs(A-B) + abs(C-D))/2,
    beta  = (abs(B-C) + abs(A-D))/2,
    K = A + unit(B-A) * alpha,
    L = B + unit(C-B) * beta,
    M = C + unit(D-C) * alpha,
    N = D + unit(A-D) * beta,
    F = extension(A, D, M, L);

// plain.N

draw(A--B--C--D--cycle, linewidth(1));

draw(L--K--N--M--cycle ^^ N--A ^^ M--D);

mark(C--L, scale(0.7) * stickframe);
mark(A--N, scale(0.7) * stickframe);

mark(B--K, scale(0.7) * tildeframe);
mark(D--M, scale(0.7) * tildeframe);

dot(Label("$A$", A, 2E));
dot(Label("$B$", B, NNE));
dot(Label("$C$", C, ESE));
dot(Label("$D$", D, SSE));
dot(Label("$K$", K, NNW));
dot(Label("$L$", L, ENE));
dot(Label("$M$", M, SSW));
dot(Label("$N$", N, WNW));

dot(Label("$F$", F, 2 plain.N));

