// https://github.com/Irev-Dev/Round-Anything
use <../Round-Anything/polyround.scad>

$fn = 100;

// Hook variables.
Hw = 40;
Hl = 45;
Hh = 6;

module hookBaseSubtractor() {
    xy = 40;
    narrow = 15;
    
    linear_extrude(cheight) {
    difference() {
        square(80, center = true);
        polygon(
            points = [
                [0,0],
                [-xy + narrow , -xy],
                [xy - narrow, -xy]
            ] 
        );
    }
}
}

module hookBase() {

    baseH = (Ph / 2) + 3;
    
    difference() {
        difference() {
            cylinder(h = cheight, r1 = cr1 + baseH, r2 = cr2 + baseH); 
            instrumentCylinder();
        }
        rotate([0, 0, 90])
        hookBaseSubtractor(); 
    }
}

module hook() {
    w = 8;
    l = 19;
    h = 3;
    r = 2;
    tilt = 1;
    
    radii = [
        [w - h, 0, r],
        [w, 0, r],
        [w + tilt, l, r],
        [w - h + tilt, l, r]
    ];

    rotate_extrude(angle = 160) {
        polygon(
            polyRound(radii, 30)
        ); 
    }
}


// Insturment cylinder variables
cheight = Hl;
cr1 = 23;
cr2 = 21;

module instrumentCylinder () {
    cylinder(h = cheight, r1 = cr1, r2 = cr2);
}

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
Ph = 6;

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
    br = 2.5;
    translate([25.5 + br, Pw2, Ph])
    cylinder(h = 1.5, r = br);
    
    // screw hole
    shr = 3.5;
    translate([13.5 + shr, Pw2, Ph])
    cylinder(h = Hh + 1, r = shr);  
  
    screwHeadR = 13 / 2;
    translate([13.5 + shr, Pw2, Ph + 2])
    cylinder(h = Hh, r = screwHeadR);  

}

module cylinderPlatformSubtractor() {
    instrumentCylinder();
    // Position the platform on the instrument cylinder
    verticalSpace = (Hl - Pl12) / 2;
    translate([cr2 - (Ph / 2), -Pw2, Pl12 + verticalSpace])
    rotate([0, 90, 0])
    platform();
    
    // Measurement
    // 0.5 mm margin of error
    ml = Ph / 2;
    %translate([cr2, 0, Pl12 + verticalSpace ])
    polygon(
        points = [
            [0, -0.5],
            [0, 0.5],
            [ml, 0.5],
            [ml, -0.5]
        ]
    );
}

   //cylinderPlatformSubtractor();
hook();
//difference() {
//   hookBase();
//   cylinderPlatformSubtractor();
//}





