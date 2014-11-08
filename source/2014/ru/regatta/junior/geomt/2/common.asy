import geometry;

real angle[]; angle[0] = -3.5; angle[1] = angle[0] + 7;

point A[];

for (int i = 0; i <= 15; ++i) {
    A[i] = dir(angle[i%2]) * Sin(7 * i) / Sin(7);
}

