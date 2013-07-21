import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

var
    A = (0,0), B = (2,0), C = (3 A + I * B) / (3 + I),
    ABC = triangle(A, B, C),
    M = midpoint(ABC.AB),
    Q = (2 C + B) / 3, Ap = 2 C - A;

draw(A--B--C--cycle, black+1);
draw(Q--A);
draw(C--M--Q);

draw(Ap--C ^^ Ap--Q ^^ Ap--B, dashed);

mark(A--M, 1);
mark(M--B, 1);
mark(Ap--C, 2);
mark(C--A, 2);

markangle(Ap, M, C, radius=mr);
markangle(M, Ap, B, radius=mr);
markangle(M, A, Q, radius=mr);

perpendicularmark(C, unit(A-C), dir=NE, size=0.5mr);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, unit(Ap-A)*I));
dot(Label("$M$", M, S));
dot(Label("$Q$", Q, NE));
dot(Label("$A'$", Ap, N));

