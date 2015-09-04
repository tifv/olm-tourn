import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    circle = circle((point)(0,0), 1),
    O = circle.C,

    A = dir(180), B = dir(30), C = dir(0), D = dir(-90),
    K = (B+D)/2, M = extension(A, C, B, D);

pen gray = gray(0.7);

draw(circle, gray+1);

draw(A--B--C--D--cycle, linewidth(1));
draw(A--C);
draw(B--D);
draw(O--B);
draw(O--D);
draw(O--K);

perpendicularmark(K, unit(M-K), dir=NE, size=0.5mr);

dot(Label("$A$", A, unit(A)));
dot(Label("$B$", B, unit(B)));
dot(Label("$C$", C, unit(C)));
dot(Label("$D$", D, unit(D)));
dot(Label("$M$", M, SE));
dot(Label("$K$", K, unit(K)));
dot(Label("$O$", O, NNW));

label("$1$", (B+M)/2, unit(B-M)/I);
label("$2$", (M+D)/2, NW+0.5N);

