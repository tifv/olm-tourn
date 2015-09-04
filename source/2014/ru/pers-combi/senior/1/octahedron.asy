import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;
from jeolm access mark;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

pair A = (3, 0), B = (0, 3), C = (1,1);

draw(A--B--C--cycle);
draw(A--(-B)--(-C)--cycle);
draw((-A)--(-B)--C--cycle);
draw((-A)--B--(-C)--cycle);

dot(A);
dot(-A);
dot(B);
dot(-B);
dot(C);
dot(-C);

