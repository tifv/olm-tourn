import geometry;

// access /_style/jeolm/ as jeolm.asy
access jeolm;

// access /common-sizes/ as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);

var
    r1 = 1, r2 = 1 / sqrt(2),

    circle1 = circle((point)(0,0), r1),
    circle2 = circle((point)(0,0), r2),

    arc1outer = arc(circle1, 90, 270),
    arc1inner = arc(circle2, 90, 270),
    arc2 = arc(circle2, 0, 180),

    piece1 = arc1outer--reverse(arc1inner)--cycle,
    piece2 = arc2--cycle;

pen grayfill = gray(0.85);

filldraw(piece1, fillpen=grayfill);
filldraw(piece2, fillpen=grayfill);

draw(circle1, linewidth(1));
draw(circle2);

