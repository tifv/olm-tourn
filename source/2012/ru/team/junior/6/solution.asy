import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0,0), B = (1,2.5), C = (2,0);

var
    ABC = triangle(A, B, C),
    M = (A + B) / 2, N = (C + B) / 2,
    M1 = (3 A + B) / 4, N1 = (3 C + B) / 4,
    M2 = extension(M1, N1, A, N),
    N2 = extension(M1, N1, C, M),

    alpha = 0.4,
    K = ((1-alpha) * A + (1+alpha) * M) / 2,
    L = ((1-alpha) * N + (1+alpha) * C) / 2,
    E = (K+L) / 2,
    D = intersectionpoint(parallel(K, (vector) C-B), line(M1, N1));

draw(ABC, linewidth(1));

draw(A--N ^^ C--M);
draw(M1--N1);
draw(K--L ^^ K--D, dashed);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, plain.N));
dot(Label("$C$", C, SSE));
dot(Label("$M$", M, WNW));
dot(Label("$N$", N, ENE));
dot(Label("$M_1$", M1, WNW));
dot(Label("$N_1$", N1, ENE));
dot(Label("$M_2$", M2, SSE));
dot(Label("$N_2$", N2, NNE));

dot(Label(scale(0.7) * "$K$", K, WNW));
dot(Label(scale(0.7) * "$L$", L, ENE));
dot(Label(scale(0.7) * "$E$", E, plain.S));
dot(Label(scale(0.7) * "$D$", D, plain.S));

