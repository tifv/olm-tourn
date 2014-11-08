// access ../common.asy as common.asy
import common;

point X = (0.5A[1]+0.5A[2]), Y = (A[6]);

draw(X--Y);

label("$n-3$", (0.5-0.2I) * X + (0.5+0.2I) * Y);

