//********************
// Normal image

import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
var mr = common.markradius;
var mark = common.mark;

var
    A = (1,0), B = (0,0), C = (0,1),
    ABC = triangle(A, B, C),

    M = centroid(ABC);

markangle(A, M, C, radius=mr);

perpendicularmark(B, unit(A-B), dir=NE, size=0.5mr);

//********************
// 3D image

import three;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);
currentprojection = perspective(65, 70, 80);
settings.render = common.render;

