import three;

// access /common-sizes.asy as common-sizes.asy
access "common-sizes.asy" as sizes;
size(sizes.size);
currentprojection = perspective(65, 70, 80);
settings.render = sizes.render;

bool coloured = false;

// Fill the parallelipiped
void mydraw_fill(triple a, triple b)
{
    draw(shift(a) * scale(b.x-a.x, b.y-a.y,b.z-a.z) * unitcube);
}

// Draw the frame of the parallelipiped
void mydraw_frame(triple a, triple b)
{
    real d = 0.05;
    mydraw_fill((a.x-d, a.y-d, a.z-d), (a.x+d, a.y+d, b.z+d));
    mydraw_fill((a.x-d, a.y-d, a.z-d), (a.x+d, b.y+d, a.z+d));
    mydraw_fill((a.x-d, a.y-d, a.z-d), (b.x+d, a.y+d, a.z+d));
    mydraw_fill((a.x-d, a.y-d, b.z-d), (b.x+d, a.y+d, b.z+d));
    mydraw_fill((a.x-d, b.y-d, a.z-d), (a.x+d, b.y+d, b.z+d));
    mydraw_fill((b.x-d, a.y-d, a.z-d), (b.x+d, b.y+d, a.z+d));
    mydraw_fill((a.x-d, a.y-d, b.z-d), (a.x+d, b.y+d, b.z+d));
    mydraw_fill((a.x-d, b.y-d, a.z-d), (b.x+d, b.y+d, a.z+d));
    mydraw_fill((b.x-d, a.y-d, a.z-d), (b.x+d, a.y+d, b.z+d));
    mydraw_fill((a.x-d, b.y-d, b.z-d), (b.x+d, b.y+d, b.z+d));
    mydraw_fill((b.x-d, b.y-d, a.z-d), (b.x+d, b.y+d, b.z+d));
    mydraw_fill((b.x-d, a.y-d, b.z-d), (b.x+d, b.y+d, b.z+d));
}

/* Alternative implementation (visually poor)
void mydraw_frame(triple a, triple b)
{
    draw(a--(a.x, a.y, b.z)--(a.x, b.y, b.z)--b);
    draw(a--(a.x, b.y, a.z)--(b.x, b.y, a.z)--b);
    draw(a--(b.x, a.y, a.z)--(b.x, a.y, b.z)--b);
    draw((a.x, a.y, b.z)--(b.x, a.y, b.z));
    draw((a.x, b.y, a.z)--(a.x, b.y, b.z));
    draw((b.x, a.y, a.z)--(b.x, b.y, a.z));
}
*/

void mydraw(triple a, triple b);

int n = 20;
triple dx=(0, 3, n-3), dy=(n-4, 0, 5), dz=(6, n-8, 0);

if (!coloured) {
    // WAR IS PEACE
    // FREEDOM IS SLAVERY
    // IGNORANCE IS STRENGTH
    red = green = blue = black;
}

// The cube
currentpen = black+opacity(0.25);
mydraw_frame((0,0,0), (n,n,n));

// Three bricks in perpendicular directions
currentpen = blue + opacity(0.25);
mydraw_fill((0, dx.y, dx.z), (n, dx.y+1, dx.z+1));
mydraw_fill((dy.x, 0, dy.z), (dy.x+1, n, dy.z+1));
mydraw_fill((dz.x, dz.y, 0), (dz.x+1, dz.y+1, n));
// Frames of the bricks
currentpen = blue;
mydraw_frame((0, dx.y, dx.z), (n, dx.y+1, dx.z+1));
mydraw_frame((dy.x, 0, dy.z), (dy.x+1, n, dy.z+1));
mydraw_frame((dz.x, dz.y, 0), (dz.x+1, dz.y+1, n));
// Opaque frames visually connecting the bricks to the cube
currentpen = black+opacity(0.1);
mydraw_frame((0, 0, dx.z), (n, dx.y, dx.z+1));
mydraw_frame((dy.x, 0, 0), (dy.x+1, n, dy.z));
mydraw_frame((0, dz.y, 0), (dz.x, dz.y+1, n));

// Frames drawn from the bricks to the single intersection.
currentpen = red;
mydraw_frame((dy.x, dx.y, dx.z), (dy.x+1, dz.y, dx.z+1));
mydraw_frame((dz.x, dz.y, dx.z), (dy.x, dz.y+1, dx.z+1));
mydraw_frame((dy.x, dz.y, dy.z), (dy.x+1, dz.y+1, dx.z));

// The intersection
currentpen = red;
mydraw_fill((dy.x, dz.y, dx.z), (dy.x+1, dz.y+1, dx.z+1));
mydraw_frame((dy.x, dz.y, dx.z), (dy.x+1, dz.y+1, dx.z+1));

/* Alternative intersection
// Frames drawn from the bricks to the single intersection.
currentpen = green;
mydraw_frame((dz.x, dx.y, dy.z+1), (dz.x+1, dx.y+1, dx.z+1));
mydraw_frame((dz.x+1, dx.y, dy.z), (dy.x+1, dx.y+1, dy.z+1));
mydraw_frame((dz.x, dx.y+1, dy.z), (dz.x+1, dz.y+1, dy.z+1));

currentpen = green;
mydraw_fill((dz.x, dx.y, dy.z), (dz.x+1, dx.y+1, dy.z+1));
mydraw_frame((dz.x, dx.y, dy.z), (dz.x+1, dx.y+1, dy.z+1));
*/

