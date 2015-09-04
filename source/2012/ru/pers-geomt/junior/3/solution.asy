import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    A = (0,0), B = (1,2.5), C = (2,0),
    ABC = triangle(A, B, C),
    inABC = incircle(A, B, C),

    F = intouch(ABC.AB),
    E = intouch(ABC.BC),
    D = intouch(ABC.CA),

    beam = line(A, A + dir(55), extendA=false),

    listPQ = intersectionpoints(beam, inABC),
    P = listPQ[0], Q = listPQ[1],

    Pp = extension(A, C, P, E),
    Qp = extension(A, C, Q, E);

pen gray = gray(0.7);

draw(beam, gray+1);

draw(ABC, linewidth(1));
draw(inABC);
draw(C--Qp--Q);
draw(A--Pp--E);
draw(Pp--F);

mark(A--D, 1);
mark(D--C, 1);

dot(Label("$A$", A, S));
dot(Label("$B$", B, N));
dot(Label("$C$", C, S));
dot(Label("$F$", F, unit(unit(B-F)*I + unit(F-Pp)*I)));
dot(Label("$E$", E, unit(unit(B-E)/I + unit(E-Qp)/I)));
dot(Label("$D$", D, S));
dot(Label("$P$", P, 1.5ESE));
dot(Label("$Q$", Q, NNW));
dot(Label("$P'$", Pp, S));
dot(Label("$Q'$", Qp, S));

