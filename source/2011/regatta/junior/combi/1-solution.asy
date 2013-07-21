import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);

path[]
    block = (0,0)--(0,1)--(4,1),
    rblock = (0,0)--(0,4)--(1,4),

    rsquare =
                     rblock ^^
        shift(1,0) * rblock ^^
        shift(2,0) * rblock ^^
        shift(3,0) * rblock,
    section =
                      block ^^
        shift(0, 1) * block ^^
        shift(0, 2) * rsquare ^^
        shift(0, 6) * block ^^
        shift(0, 7) * rsquare ^^
        shift(0,11) * block ^^
        shift(0,12) * rsquare ^^
        (0,0)--(4,0),
    rsection = shift(0,16) * yscale(-1) * section;

draw(shift( 0,0) * section);
draw(shift( 4,0) * rsection);
draw(shift( 8,0) * section);
draw(shift(12,0) * rsection);
draw((16,0)--(16,16));

