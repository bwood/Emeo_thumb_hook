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
    // l12: Total length.  +1 for margin of error.
    l12 = l1 + l2 + 1;
    w2 = w1 / 2;
    // polyround radius
    r1 = 10;
    
    radii = [
        // x, y, radius
        [0, 0, 0], 
        [0, w1, 0], 
        [l1, w1, r1], 
        [l1 + (l2 / 2), w1 , r1 * 2],
        // End point.
        [l12, w2, 2], 
        [l1 + (l2 / 2), w1 - w1, r1 * 2],
        [l1, 0, r1], 
        [0, 0, 0]
    ];

    //measure
    translate([0,0,-1]) {
    color("Lime") {
        polygon(
            points = [
                [0, (w1 / 2) - 1], 
                [0, (w1 / 2) + 1],
                [l1 + l2, (w1 / 2) + 1],
                [l1 + l2, (w1 / 2) - 1] 
            ]       
        );
    }
}
    color("Gold") {
    polygon(
        polyRound(radii, 30)
    );
    }
}



platform();