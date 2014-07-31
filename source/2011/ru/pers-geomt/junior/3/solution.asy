import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (1,3), B = (0,0), C = (5,0),
    ABC = triangle(A, B, C),

    L = bisectorpoint(ABC.BC),
    M = midpoint(ABC.BC),
    X = intersectionpoint(perpendicular(L, ABC.BC), line(A, M)),
    P = projection(A, B) * L,
    Q = projection(A, C) * L;

draw(ABC, linewidth(1));
draw(A--L);
draw(A--M);
draw(L--X);
draw(L--Q);
draw(L--P);
draw(P--Q, dashed);

mark(P--A, 1);
mark(Q--A, 1);
mark(P--L, 2);
mark(Q--L, 2);

markangle(A, C, B, radius=mr);
markangle(Q, L, X, radius=mr);
markangle(C, B, A, radius=0.7mr, n=2);
markangle(X, L, P, radius=0.7mr, n=2);

markangle(B, A, L, radius=mr, n=3);
markangle(L, A, C, radius=1.3mr, n=3);

perpendicularmark(L, unit(C-L), dir=NE, size=0.5mr);
perpendicularmark(P, unit(L-P), dir=NE, size=0.5mr);
perpendicularmark(Q, unit(L-Q), dir=SE, size=0.5mr);

dot(Label("$A$", A, N));
dot(Label("$B$", B, SW));
dot(Label("$C$", C, SE));
dot(Label("$L$", L, S));
dot(Label("$M$", M, S));
dot(Label("$X$", X, 1.5dir(70)));
dot(Label("$P$", P, NW));
dot(Label("$Q$", Q, NE));

