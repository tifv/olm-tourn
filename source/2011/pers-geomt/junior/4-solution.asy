import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mark = common.mark;

var
    A = (0,0), B = (0,3), D = (5,2), C = (1,4),
    M = C + (D - B),
    N = A + (D - B);

draw(A--B--C--D--cycle);
draw(A--C);
draw(B--D);
draw(N--D--M, dashed);
draw(A--N--M--C, dashed);

mark(A--B, 1);
mark(N--D, 1);
mark(B--C, 2);
mark(D--M, 2);

dot(Label("$A$", A, WSW));
dot(Label("$B$", B, WNW));
dot(Label("$C$", C, NNW));
dot(Label("$D$", D, ESE));
dot(Label("$M$", M, NE));
dot(Label("$N$", N, SSE));

