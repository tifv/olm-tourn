import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

pair
    A = (-3,0), B = (0,0), C = (5,0),
    Ap = rotate(-60) * A,

    M = 2.5 dir(140), N = rotate(-60) * M;

draw(A--B--M--cycle, linewidth(1));
draw(B--C--N--cycle, linewidth(1));
draw(M--N);
draw(B--Ap--N, dashed);

markangle(B, M, N, radius=mr);
markangle(M, N, B, radius=mr);

markangle(N, B, M, radius=0.8mr);
//markangle(Ap, B, A, radius=1.1mr);

mark(A--B, 2);
mark(Ap--B, 2);
mark(A--M, 1);
mark(Ap--N, 1);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, S));
dot(Label("$C$", C, SE));
dot(Label("$M$", M, NW));
dot(Label("$N$", N, NNE));
dot(Label("$A'$", Ap, NNW));

