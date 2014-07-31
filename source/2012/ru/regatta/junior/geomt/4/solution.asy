import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    circle = circle((point)(0,0), 1),

    A = dir(90), B = dir(-120), C = A * A / B, D = C * C / B,
    X = unit(D + C),
    O = extension(A, C, B, D),
    Y = extension(A, X, B, D), Z = extension(A, C, B, X);

pen gray = gray(0.7);
draw(circle, gray+1);

draw(A--B--C--D--cycle, linewidth(1));
draw(A--C ^^ B--D);
draw(X--O);

draw(A--X--B);

perpendicularmark(Y, unit(A-Y), dir=NE, size=0.5mr);
perpendicularmark(Z, unit(A-Z), dir=NE, size=0.5mr);

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

