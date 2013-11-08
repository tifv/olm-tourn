import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (1,3), C = (5,0),
    ABC = triangle(A, B, C),
    M = (pair) midpoint(ABC.AC),
    alpha = (4,0),
    a = (pair) (alpha),
    b = (pair) (B - A - alpha * (M + B)),
    c = (pair) (alpha * M * B + A * C - B * C),
    PP = quadraticroots(a, b, c),
    P = (pair) PP[0], P2 = (pair) PP[1],
    ABP = triangle(A, B, P),
    circumABP = circumcircle(ABP),
    O = circumABP.C,
    Q = O + (P-O) * line(M, P).v ^ 2 / unit(P - O) ^ 2,
    Pp = A + C - P;

clipdraw(circumABP, gray(0.5));
draw(line(M, Q), gray(0.5));

draw(A--B--C--cycle, linewidth(1));
draw(A--P ^^ B--P ^^ C--P);
draw(Pp--A, dashed);
draw(Q--A, dashed);

mark(A--M, 2);
mark(M--C, 2);

mark(P--M, 1);
mark(M--Pp, 1);

markangle(A, B, P, n=2, radius=mr);
markangle(A, Q, P, n=2, radius=mr);
markangle(P,Pp, A, n=2, radius=mr);
markangle(M, P, C, n=2, radius=mr);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, NE));
dot(Label("$C$", C, SE));
dot(Label("$M$", M, SW));
dot(Label("$P$", P, NE));
//dot(Label("$P_2$", P2, E));
dot(Label("$P'$", Pp, SW));
dot(Label("$Q$", Q, N));

