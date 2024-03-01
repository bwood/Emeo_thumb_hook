// https://github.com/Irev-Dev/Round-Anything
use <../Round-Anything/polyround.scad>

$fn = 100;
cheight = 35;
cPr1 = 22.25;
cr2 = 21.5;

//cylinder(h = cheight, Pr1 = cPr1, r2 = cr2);


// Platform variables
Pw1 = 19;
Pl1 = 26;
Pl2 = 9; 
// Pl12: Total length.  +1 for margin of error.
Pl12 = Pl1 + Pl2 + 1;
Pw2 = Pw1 / 2;
// polyround radius
Pr1 = 10;

// height from instrument cylinder at top of platform.
Ph = 4;

module platform () {
    
    radii = [
        // x, y, radius
        [0, 0, 0], 
        [0, Pw1, 0], 
        [Pl1, Pw1, Pr1], 
        [Pl1 + (Pl2 / 2), Pw1 , Pr1 * 2],
        // End point.
        [Pl12, Pw2, 2], 
        [Pl1 + (Pl2 / 2), Pw1 - Pw1, Pr1 * 2],
        [Pl1, 0, Pr1], 
        [0, 0, 0]
    ];

    // Measurement.
    %translate([0,0,-1]) {
        polygon(
            points = [
                [0, (Pw1 / 2) - 1], 
                [0, (Pw1 / 2) + 1],
                [Pl1 + Pl2, (Pw1 / 2) + 1],
                [Pl1 + Pl2, (Pw1 / 2) - 1] 
            ]       
            );
    }
    

    linear_extrude(Ph) {
        polygon(
            polyRound(radii, 30)
        );
    }
    
    // bump.
    // subtract the 1 margin of error in Pl12
    translate([25.5, Pw2, Ph])
    cylinder(h = 0, r = 2.5, h = 1.5);
        

}

// Hook variables.
Hw = 40;
Hl = 45;
Hh = 6;

module hook() {
    linear_extrude(Hh) {
        polygon(
            points = [
                [0,0],
                [0, Hw],
                [Hl, Hw],
                [Hl, 0]   
            ]
        );
    }
}

platform();
//difference() {
//    hook();
//    translate([0, (Hw - Pw1) / 2], 0)
//    platform();
//}


