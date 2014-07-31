import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (2,0), C = (3 A + I * B) / (3 + I),
    ABC = triangle(A, B, C),
    M = midpoint(ABC.AB),
    Q = (2 C + B) / 3, Ap = 2 C - A;

draw(ABC, linewidth(1));
draw(Q--A);
draw(C--M--Q);

draw(Ap--C ^^ Ap--Q ^^ Ap--B, dashed);

mark(A--M, 1);
mark(M--B, 1);
mark(Ap--C, 2);
mark(C--A, 2);

markangle(Ap, M, C, radius=1.2mr);
markangle(M, A, Q, radius=1.2mr);
markangle(M, Ap, B, radius=1.4mr);

perpendicularmark(C, unit(A-C), dir=NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, unit(Ap-A)*I));
dot(Label("$M$", M, S));
dot(Label("$Q$", Q, NE));
dot(Label("$A'$", Ap, N));

