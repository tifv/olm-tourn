import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;

var
    alpha = 70,
    A = (0,0), D = A + dir(alpha), C = D + dir(0), B = C + dir(-alpha),
    beta = 55,
    E = intersectionpoint(line(D, C), parallel(A, dir(beta))),
    F = intersectionpoint(line(C, B), parallel(E, dir(beta - alpha)));

void mark(path p) {
    draw(p,
        marker(markinterval(tildeframe(1), rotated=true)),
        p=invisible );
};

draw(A--B--C--D--cycle);
draw(A--E--F);

mark(B--C);
mark(C--D);
mark(D--A);

markangle(A, D, C, radius=0.7mr);
markangle(D, C, B, radius=0.7mr);

markangle(E, A, D, radius=1.7mr, n=2);
markangle(F, E, C, radius=2.1mr, n=2);

dot(Label("$A$", A, SW));
dot(Label("$B$", B, SE));
dot(Label("$C$", C, NNE));
dot(Label("$D$", D, NW));
dot(Label("$E$", E, N));
dot(Label("$F$", F, ENE));

