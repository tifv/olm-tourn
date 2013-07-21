import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;

var
    circ = circle((point)(0,0), 1),

    A = dir(90), B = dir(-120), C = A * A / B, D = C * C / B,
    X = unit(D + C),
    O = extension(A, C, B, D),
    Y = extension(A, X, B, D), Z = extension(A, C, B, X);

// gray
draw(A--X--B, p=gray(0.5));
perpendicularmark(Y, unit(A-Y), dir=NE, size=0.5mr, p=gray(0.5));
perpendicularmark(Z, unit(A-Z), dir=NE, size=0.5mr, p=gray(0.5));

draw(circ);
draw(A--B--C--D--cycle, p=linewidth(1));
draw(A--C ^^ B--D);
draw(X--O);

draw(
    arccircle(C, X, D),
    marker(markinterval(2, stickframe(1), rotated=true)),
    p=invisible );

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));
dot(Label("$X$", X, unit(X)));
dot(Label("$O$", O, unit(unit(A-O)+unit(B-O))));

markangle(C, A, D, radius=1.3mr, n=2);
markangle(C, B, D, radius=1.5mr, n=2);
markangle(B, D, C, radius=1.5mr, n=2);
markangle(B, A, C, radius=1.6mr, n=2,
    L=Label(scale(0.7) * "$2\alpha$") );

markangle(C, B, A, radius=0.8mr, n=1);
markangle(A, C, B, radius=0.8mr, n=1,
    L=Label(scale(0.7) * "$90^\circ - \alpha$", align=W) );

