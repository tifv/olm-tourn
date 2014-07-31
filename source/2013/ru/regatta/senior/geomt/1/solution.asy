import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (1,1), C = (2,0),
    ABC = triangle(A, B, C),
    alpha = 25,
    M = (1-Tan(alpha), 0), N = (1+Tan(45-alpha), 0),
    X = B + sqrt(2) * dir(-45 - 2 alpha);

draw(ABC, linewidth(1));
draw(B--M ^^ B--N);
draw(M--X ^^ N--X ^^ B--X, dashed);

mark(A--B, 1);
mark(B--C, 1);

mark(A--M, 2);
mark(M--X, 2);

mark(X--N, 3);
mark(N--C, 3);

// plain.N

dot(Label("$A$", A, SW));
dot(Label("$B$", B, plain.N));
dot(Label("$C$", C, SE));

dot(Label("$M$", M, SW));
dot(Label("$N$", N, SE));

dot(Label("$X$", X, S));

