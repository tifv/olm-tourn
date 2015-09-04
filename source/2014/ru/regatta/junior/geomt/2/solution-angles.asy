import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

// access ../common/ as common.asy
import "common.asy" as common;

dot(A[0], white);

draw(line(A[0], A[12]), gray(0.7) + 1);
draw(line(A[0], A[13]), gray(0.7) + 1);
draw(A[12]--A[13]);

dot(Label("0", A[0], S));
dot(Label(scale(0.7) * "12", A[12], S));
dot(Label(scale(0.7) * "13", A[13], N));

label(
    scale(0.7) * "$89^\circ$", A[12],
    unit(A[0]-A[12])+unit(A[13]-A[12])
);
label(
    scale(0.7) * "$84^\circ$", A[13],
    unit(A[0]-A[13]) + unit(A[12]-A[13])
);

