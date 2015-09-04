import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (0,0), B = (1,4), C = (5,0),
    ABC = triangle(A, B, C),
    O = circumcenter(ABC),
    A1 = projection(ABC.BC) * A,
    B1 = projection(ABC.AC) * B;

pen grayfill = gray(0.85);

fill(A--O--B1--cycle, grayfill);
fill(B--O--A1--cycle, grayfill);

draw(A--B--C--cycle, linewidth(1));
draw(A--O--B1 ^^ B--O--A1);
draw(A--A1 ^^ B--B1);

markangle(C, A, B, L=Label("$\alpha$", align=2N), n=1, radius=0.8mr);
markangle(A, B, C, L="$\beta$", n=2, radius=0.8mr);

perpendicularmark(B1, unit(B-B1), dir=NE, size=0.5mr);
perpendicularmark(A1, unit(B-A1), dir=NE, size=0.5mr);

dot(Label("$A$", A, SSW));
dot(Label("$B$", B, NNW));
dot(Label("$C$", C, SSE));
dot(Label("$O$", O, ESE));
dot(Label("$A_1$", A1, NE));
dot(Label("$B_1$", B1, S));
label("$c$", (A+B)/2, unit(A-B)/I);
