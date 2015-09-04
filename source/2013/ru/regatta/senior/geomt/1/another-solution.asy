import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (1,1), C = (2,0),
    ABC = triangle(A, B, C),
    alpha = 25,
    M = (1-Tan(alpha), 0), N = (1+Tan(45-alpha), 0),
    D = C + (M - A) * I;

draw(ABC, linewidth(1));
draw(B--M ^^ B--N);
draw(B--D--C ^^ N--D, dashed);

mark(A--B, 1);
mark(B--C, 1);

mark(A--M, 2);
mark(C--D, 2);

perpendicularmark(C, unit(D-C), dir=NE, size=0.5mr);

// plain.N

dot(Label("$A$", A, SW));
dot(Label("$B$", B, plain.N));
dot(Label("$C$", C, SE));

dot(Label("$M$", M, S));
dot(Label("$N$", N, S));

dot(Label("$D$", D, NE));

