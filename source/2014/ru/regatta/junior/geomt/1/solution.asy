import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

point
    A = (0,0), B = (3, 0), C = (1, 3);
triangle ABC = triangle(A, B, C);
circle inABC = incircle(ABC);

point
    L = (-1.5, 0), O = inABC.C,
    N = reflect(L, inABC.C) * projection(ABC.AB) * O,
    K = extension(L, N, A, C);

draw(inABC, gray(0.7) + 1);

draw(ABC, linewidth(1));

draw(line(A, L));
draw(line(L, N, extendA=false));

draw(L--O ^^ K--O ^^ A--O);

markangle(A, L, O, radius=mr);
markangle(O, L, K, radius=mr);

dot(Label("$A$", A, S));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, plain.N));
dot(Label("$L$", L, SSW));
dot(Label("$K$", K, NW));
dot(Label("$O$", O, E));

label(scale(0.7) * "$x$", L, 5 unit(unit(O-L) + unit(K-L)));
label(scale(0.7) * "$x$", L, 5 unit(unit(O-L) + unit(A-L)));

