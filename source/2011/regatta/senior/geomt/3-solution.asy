import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;

pair
    A = (-3,0), B = (0,0), C = (5,0),
    Ap = rotate(-60) * A,

    M = 2.5 dir(140), N = rotate(-60) * M;

draw(A--B--C--N--M--cycle);
draw(M--B--N);
draw(B--Ap--N, linetype(new real[] {6, 7}));

markangle(N, B, M, radius=mr);
markangle(B, M, N, radius=mr);
markangle(M, N, B, radius=mr);
markangle(Ap, B, A, radius=0.7mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, S));
dot(Label("$C$", C, SE));
dot(Label("$M$", M, NW));
dot(Label("$N$", N, NNE));
dot(Label("$A'$", Ap, NNW));

