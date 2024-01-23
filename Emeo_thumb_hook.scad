// https://github.com/Irev-Dev/Round-Anything
use <../Round-Anything/polyround.scad>

$fn = 100;
cheight = 35;
cr1 = 22.25;
cr2 = 21.5;

//cylinder(h = cheight, r1 = cr1, r2 = cr2);

module platform () {
    w1 = 19;
    l1 = 20;
    l2 = 15; 
    w2 = w1 / 2;
    // polyround radius
    r1 = 10;
    
    radii = [
        // x, y, radius
        [0, 0, 0], 
        [0, w1, 0], 
        [l1, w1, r1], 
        [l1 + l2, w2, 0], 
        [l2, 0, r1], 
        [0, 0, 0]
    ];
    
    //polygon([[0,0], [0,w1], [l1,w1], [l1 + l2,w2], [l2,0], [0,0]]);
    polygon(
        polyRound(radii, 30)
    );
}

platform();