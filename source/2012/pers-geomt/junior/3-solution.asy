import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);

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

draw(beam, gray(0.5));
draw(ABC, black+1);
draw(inABC);
draw(C--Qp--Q);
draw(A--Pp--E);
draw(Pp--F);

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

