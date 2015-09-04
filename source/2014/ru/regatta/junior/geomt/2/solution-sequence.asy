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

draw(line(A[0], A[1], extendA=false), gray(0.7) + 1);
draw(line(A[0], A[2], extendA=false), gray(0.7) + 1);

transform label_scale(int i) {return scale(10 / (10 + i));}

for (int i = 0; i < 13; ++i) {
    draw(A[i]--A[i+1]);
}

for (int i = 0; i <= 12; ++i) {
    dot(Label(
        label_scale(i) * string(i), A[i], (S + 2 plain.N * (i%2))
    ));
}

dot(Label(
    label_scale(13) * "13", A[13], NNE
));

for (int i = 13; i <= 13; ++i) {
    dot(A[i]);
}

