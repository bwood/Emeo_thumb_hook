// https://github.com/Irev-Dev/Round-Anything
use <../Round-Anything/polyround.scad>

$fn = 100;

// Hook variables.
Hl = 50;
Hh = 6;

// radius for polyRound functions
r = 0.5;

// Insturment cylinder variables
cheight = Hl;
cr1 = 21;
cr2 = 22.5;
// Cylinder representing instrument body around thumbhook.
module instrumentCylinder () {
    cylinder(h = cheight, r1 = cr2, r2 = cr1);
}


// Rectangle with wedge cut out, to be subtracted from hookBase.
module hookBaseSubtractor() {
    
    xy = 40;
    narrow = 15;
    addLeft = 20;
    
    linear_extrude(cheight) {
        difference() {
            square(80, center = true);
            polygon(
                points = [
                    [0,0],
                    [-xy + narrow - addLeft , -xy],
                    [xy - narrow, -xy]
                ] 
            );
        }
    }
}

// Hook Base variables.
// height from instrument cylinder at top of platform.
Ph = 6;
baseH = (Ph / 2) + 4;

radiiHb = [
    [cr2, 0, r],
    [cr2 + baseH, 0, r],
    [cr1 + baseH, cheight, r],
    [cr1, cheight, r]
];

// Piece of a hollow cylinder that will serve as base for our thumbhook.
module hookBase() {
    // Got 108 using the law of cosines to calculate the angle that would result in a measurement of 37mm for the 3rd side of the isosceles triangle. See notes in 3d.org.
    rotHb = 108;
    
    rotate([0, 0, -65])
    rotate_extrude(angle = rotHb) {
        polygon(
            polyRound(radiiHb, 30) //todo 30 to variable.
        );
    }
    
    // Right side.
    rotate([90, 0, 45])
    hookBaseSide();
    
    // Left side.

}
//    rotate([0, 0, -68])
//    translate([cr2 + (baseH / 2), 0, 0])
    translate([cr2 + (baseH / 2), 0, cheight / 2])
    rotate([-90, 0, 0])
    translate([-cr2 - (baseH / 2), -cheight / 2, 0])
    hookBaseSide();

//todo need parameter to change the rounded side.
module hookBaseSide() {
    polyRoundExtrude(radiiHb, 1, 0, r, fn=20);
}



// The thumbhook to be placed on the hookBase.
module hook() {
    w = 9.5;
    l = 19;
    h = 3;
    tilt = 1.5;
    hrot = 140;
    
    // main hook
    radii = [
        [w, 0, r],
        [w + h, 0, r],
        [w + h, l, r],
        [w, l, r]
    ];

    rotate_extrude(angle = hrot) {
        polygon(
            polyRound(radii, 30)
        ); 
    }
    
    // hook tip
    // transform the square to a circle with this radius calculation.
    tr = l / 2;
    tipRadii = [
        [0, 0, tr],
        [0, l, tr],
        [l, l, tr],
        [l, 0, tr],        
    ];
    
    
    rotate([0, 0, hrot])
    translate([w, 0, 0])
    rotate([90, 0, 90])
    translate([-w, 0, 0])
    color("LimeGreen")
    // cut the disc in half.
    difference() {
        polyRoundExtrude(tipRadii, h, r, r, fn=20);
        translate([-(l / 2), 0, 0])
        linear_extrude(h) {
            polygon([
                [0, 0],
                [0, l],
                [l, l],
                [l, 0]
            ]);   
        }
    }
    
    // Hook wedge: Additional material for base of hook where it attaches to the platform.
    translate([w, -tilt, 0])
    rotate([90, 0, 90])
    difference() {
        // Rectangular addition.    
        radiiAddition = [
            [0, 0, r],
            [h, 0, r],
            [h, l, r],
            [0, l, r]
        ];

        translate([0, 0, h])
        rotate([0, 90, 0])
        linear_extrude(tilt) {
            polygon(
                polyRound(radiiAddition, 30)
            ); 
        }

        // Wedge to subtract from the rectangular additional above.
        radii = [
            [0, 0],
            [tilt, 0],
            [0, l]
        ];    
        

        color("LimeGreen")
        linear_extrude(h) {
            polygon(
                radii          
            );
        }
    }
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

// The shield-shaped platform to which the standard Emeo thumbhook attachs.
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

// Cylinder + thumbhook platform, to be subtracted from hookBase.    
module cylinderPlatformSubtractor() {
    instrumentCylinder();
    // Position the platform on the instrument cylinder.
    // Verticle space from top of platform to keypad guard (F#).
    verticalSpace = 10;
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
//hookBaseSubtractor();
//hookBase();

//hook();

// The base that fits over the screw hole.
difference() {
   hookBase();
   cylinderPlatformSubtractor();
}





