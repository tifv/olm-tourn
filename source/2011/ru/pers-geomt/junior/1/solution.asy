import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,4), B = (5,0), C = (0,0),
    ABC = triangle(A, B, C),

    A1 = midpoint(ABC.BC),
    M = centroid(ABC),
    K = intersectionpoint(parallel(M, ABC.AC), ABC.AB),
    L = midpoint(ABC.AB);

draw(ABC, linewidth(1));
draw(A--A1);
draw(C--M--K--cycle);
draw(M--L, p=dashed);

mark(C--K, 1);
mark(M--A, 1);

markangle(L, C, A, radius=mr);
markangle(C, A, B, radius=mr);

dot(Label("$A$", A, NW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, SW));
dot(Label("$A_1$", A1, S));
dot(Label("$M$", M, 1.5E));
dot(Label("$K$", K, NE));
dot(Label("$L$", L, NE));

