import geometry;
access jeolm;

// use /common-sizes.asy as common-sizes.asy
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

draw(circle1);
draw(circle2);

pen fillpen = gray(0.5);
filldraw(piece1, fillpen=fillpen);
filldraw(piece2, fillpen=fillpen);

