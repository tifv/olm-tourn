//********************
// Normal image

import geometry;
access jeolm;
from jeolm access mark;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
var mr = sizes.markradius;

var
    A = (1,0), B = (0,0), C = (0,1),
    ABC = triangle(A, B, C),

    M = centroid(ABC);

mark(M--A, 1);

markangle(A, M, C, radius=mr);

perpendicularmark(B, unit(A-B), dir=NE, size=0.5mr);

dot(Label("$A$", A, NW));

//********************
// 3D image

import three;

// use /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
currentprojection = perspective(65, 70, 80);
settings.render = sizes.render;

