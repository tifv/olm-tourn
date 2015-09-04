import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(1.2sizes.size);
var mr = sizes.markradius;

real alpha = 1.35;

point
    A = (0, 0), D = (-0.28, 1.27), B = (-1, 0),
    C = intersectionpoint(
        rotate(degrees(alpha), B) * line(B, A),
        rotate(degrees(-alpha), D) * line(D, A)
    ),
    P = extension(A, B, D, C), Q = extension(A, D, B, C);

circle
    BDPQ = circumcircle(B, D, P);

line
    bisecA = bisector(A, D, A, B, sharp=false),
    bisecB = bisector(B, A, B, C, sharp=false),
    bisecC = bisector(C, B, C, D, sharp=false),
    bisecD = bisector(D, C, D, A, sharp=false),
    bisecP = bisector(A, B, D, C, sharp=false),
    bisecQ = bisector(A, D, B, C, sharp=false);

point
    E = intersectionpoint(bisecA, bisecB),
    F = intersectionpoint(bisecB, bisecC),
    G = intersectionpoint(bisecC, bisecD),
    H = intersectionpoint(bisecD, bisecA),
    K = extension(E, G, F, H);

pen shortdashed = linetype(new real[] {3,3});

clipdraw(BDPQ, gray(0.7) + 1 + shortdashed);
draw(arc(BDPQ, P, Q), p=invisible);

draw(A--B--C--D--cycle, linewidth(1));
//draw(E--F--G--H--cycle);

draw(B--P ^^ P--C);
draw(C--Q ^^ Q--D);

draw(A--E ^^ B--E ^^ C--G ^^ D--G);

draw(line(Q, K, extendA=false), dashed);

markangle(B, Q, K, n=3, radius=1.25mr);
markangle(K, Q, D, n=3, radius=mr);

markangle(D, A, E, n=1, marker(markinterval(stickframe(1), true)), radius=0.85mr);
markangle(E, A, B, n=1, marker(markinterval(stickframe(1), true)), radius=0.7mr);

markangle(A, B, E, n=2, marker(markinterval(stickframe(1), true)), radius=0.85mr);
markangle(E, B, C, n=2, marker(markinterval(stickframe(1), true)), radius=0.7mr);

markangle(B, C, G, n=1, radius=0.5mr);
markangle(G, C, D, n=1, radius=0.7mr);

markangle(C, D, G, n=2, radius=0.5mr);
markangle(G, D, A, n=2, radius=0.7mr);

dot(Label("$A$", A, SE));
dot(Label("$B$", B, SSE));
dot(Label("$C$", C, NW));
dot(Label("$D$", D, ENE));
dot(Label("$E$", E, ENE));
dot(Label("$G$", G, ESE));
dot(Label("$P$", P, NNW));
dot(Label("$Q$", Q, WSW));
dot(Label("$K$", K, W));

