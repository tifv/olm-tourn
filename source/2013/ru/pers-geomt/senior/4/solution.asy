import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

real
    circumR = 1, inR = 0.44, d = sqrt(circumR * (circumR - 2 inR));
point
    O = (0, 0), I = (d, 0);
circle
    circumABC = circle(O, circumR),
    inABC = circle(I, inR);
point
    A1 = I + inR * unit(O-I) * plain.I;
line
    A1B = line(A1, A1 + unit(O-I), extendA=false),
    A1C = complementary(A1B);
point
    B = intersectionpoints(A1B, circumABC)[0],
    C = intersectionpoints(A1C, circumABC)[0];
line
    BA = parallel(B, (I-B)^2 / (A1-B)),
    CA = parallel(C, (I-C)^2 / (A1-C));
point
    A = intersectionpoint(BA, CA);
triangle
    ABC = triangle(A, B, C);
point
    B1 = foot(ABC.VB), C1 = foot(ABC.VC),
    H = extension(B, B1, C, C1),
    M = midpoint(ABC.BC),
    N = (A + H) / 2,
    L = O + circumR * unit(B + C - 2 O),
    K = 2O - L;

// plain.N

pen gray = gray(0.7);

draw(circumABC, gray+1);

draw(ABC, linewidth(1));

draw(A--H ^^ A--O ^^ A--I);

draw(O--I);
draw(K--L);

draw(L--I ^^ M--I ^^ K--I);

mark(A--N, scale(0.7) * tildeframe);
mark(N--H, scale(0.7) * tildeframe);
mark(O--M, scale(0.7) * tildeframe);

mark(B--M);
mark(M--C);

markangle(M, I, L, radius=mr, n=2);
markangle(L, K, I, radius=mr, n=2);

markangle(O, A, I, radius=mr, n=1);
markangle(I, A, H, radius=0.7mr, n=1);

dot(Label("$A$", A, unit(A-O)));
dot(Label("$B$", B, unit(B-O)));
dot(Label("$C$", C, unit(C-O)));
dot(Label("$O$", O, WSW));
dot(Label("$I$", I, ESE));
dot(Label("$H$", H, SSE));
dot(Label("$M$", M, SW));
dot(Label("$N$", N, SW));
dot(Label("$L$", L, unit(L-O)));
dot(Label("$K$", K, unit(K-O)));




