import geometry;

// access /_style/jeolm.asy as jeolm.asy
access jeolm;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    b = 0.6,
    a = b + b^2, c = 1,
    BCA = triangleabc(b, c, a),
    A = BCA.C, B = BCA.A, C = BCA.B,
    ABC = triangle(A, B, C),
    L = bisectorpoint(ABC.BC);

draw(ABC, linewidth(1));
draw(A--L);

markangle(B, A, L, radius=mr);
markangle(L, A, C, radius=1.3mr);

dot(Label("$A$", A, unit(A-L)));
dot(Label("$B$", B, SW));
dot(Label("$C$", C, SE));
dot(Label("$L$", L, S));

label("$2007$", (A+B)/2, unit(B-A)/I);
label("$a$", (A+C)/2, unit(A-C)/I);
label("$a$", (B+L)/2, unit(L-B)/I);
label("$b$", (C+L)/2, unit(C-L)/I);

