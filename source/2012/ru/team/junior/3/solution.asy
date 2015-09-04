import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0,0), B = (5,0), C = (1,3);

var
    ABC = triangle(A, B, C),
    Cp = bisectorpoint(ABC.AB),
    KL = bisector(C, Cp),
    K = intersectionpoint(KL, ABC.AC),
    L = intersectionpoint(KL, ABC.BC),
    X = extension(C, Cp, K, L);

draw(A--K--L--B--cycle, linewidth(1));
draw(K--C--L ^^ K--Cp--L);
draw(C--Cp, dashed);

markangle(A, K, L, radius=0.7mr);
markangle(K, L, B, radius=0.7mr);

mark(C--X, tildeframe(1));
mark(Cp--X, tildeframe(1));
perpendicularmark(X, unit(Cp-X), dir=NE, size=0.5mr);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, SSE));
dot(Label("$C$", C, NNW));
dot(Label("$K$", K, WNW));
dot(Label("$L$", L, NE));
dot(Label("$C'$", Cp, S));
dot(X);

