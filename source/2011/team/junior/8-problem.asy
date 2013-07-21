import geometry;

// use /common.asy as common.asy
access "common.asy" as common;
size(common.size);

real a = sqrt(3) / 2;

path[] piece;

for (int i = -3; i <= 3; ++i) {
    piece[i+3] = (0, a * i)--(3 - .5 abs(i), a * i);
}

for (int j = 0; j < 360; j += 60) {
    draw(rotate(j) * piece);
}

