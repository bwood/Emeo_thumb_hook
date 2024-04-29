// https://github.com/Irev-Dev/Round-Anything
use <../Round-Anything/polyround.scad>

//$fn = 20;
fnPolyRound = 4; //20;
// Epsilon. This small value guarantees overlap and solves the warning: "Object may not be a valid 2-manifold and may need repair!"
eps = 0.01;

// Hook variables.
Hl = 48;
Hh = 6;

// radius for polyRound functions
r = 1;

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
Ph = 5;
baseH = (Ph / 2) + 2.5;

radiiHb = [
    [cr2, 0, r],
    [cr2 + baseH, 0, r],
    [cr1 + baseH, cheight, r],
    [cr1, cheight, r]
];

// Piece of a hollow cylinder that will serve as base for our thumbhook.
module hookBase() {
    // Got 108 using the law of cosines to calculate the angle that would result in a measurement of 37mm for the 3rd side of the isosceles triangle. See notes in 3d.org. Angle of 108 deb results in 37mm. Using the screw hole for orientation, I've reduced that angle a bit while tweeking the position of the thumbhook.
    rotHb = 90;
    
    rotate([0, 0, -48])
    rotate_extrude(angle = rotHb) {
        polygon(
            polyRound(radiiHb, 30) //todo 30 to variable.
        );
    }
    
    // Right side.
    rotate([90, 0, 44])
    hookBaseSide();
    
    // Left side.
    rotate([90, 0, -48 - eps])
    hookBaseSide(true);

}


//todo need parameter to change the rounded side.
module hookBaseSide(roundTop = false) {
    if (roundTop) {
        polyRoundExtrude(radiiHb, 1, r, 0, fn=fnPolyRound);        
    }
    else {
        polyRoundExtrude(radiiHb, 1, 0, r, fn=fnPolyRound);
    }
}



// The thumbhook to be placed on the hookBase.
thH = 3;
module hook() {
    w = 9.5;
    l = 19;
    tilt = 1.5;
    hrot = 140;
    
    // main hook
    radii = [
        [w, 0, r],
        [w + thH, 0, r],
        [w + thH, l, r],
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
        polyRoundExtrude(tipRadii, thH, r, r, fn=fnPolyRound);
        translate([-(l / 2), 0, 0])
        linear_extrude(thH) {
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
            [thH, 0, r],
            [thH, l, r],
            [0, l, r]
        ];

        translate([0, 0, thH])
        rotate([0, 90, 0])
        linear_extrude(tilt) {
            polygon(
                polyRound(radiiAddition, 30)
            ); 
        }

        // Wedge to subtract from the rectangular additional above.
//        radii = [
//            [0, 0],
//            [tilt, 0],
//            [0, l]
//        ];    
        

//        color("LimeGreen")
//        linear_extrude(thH) {
//            polygon(
//                radii          
//            );
//        }
    }
}




// Platform variables
// +1 for margin of error.
Pw1 = 19 + 1;
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

    // Measurement: Height of platform off cylinder.
    //    %translate([0,0,-1]) {
    //        polygon(
    //            points = [
    //                [0, (Pw1 / 2) - 1], 
    //                [0, (Pw1 / 2) + 1],
    //                [Pl1 + Pl2, (Pw1 / 2) + 1],
    //                [Pl1 + Pl2, (Pw1 / 2) - 1] 
    //            ]       
    //            );
    //    }
    

    linear_extrude(Ph) {
        polygon(
            polyRound(radii, 30)
        );
    }
    
    // bump
    // bump radius + 0.5 margin of error
    br = 2.5 + 0.5;
    bumpH = 1 + 0.5; 
    bumpDistFromEnd = 3.5;
    // subtract the half the margin of error in Pl12 (0.5)
    translate([Pl12 - 0.5 - bumpDistFromEnd - br, Pw2, Ph])
    cylinder(h = bumpH, r = br);
    
    // screw hole
    // radius: measure the raised area surrounding the hole on the plaform.
    shr = 3.5;
    shDistFromTop = 12.3;
    translate([shDistFromTop + shr + 0.5, Pw2, Ph])
    cylinder(h = Hh + 1, r = shr);  
  
    sHeadR = 13 / 2;
    sHeadHeightOffPlatform = 1.5;
    translate([shDistFromTop + shr + 0.5, Pw2, Ph + sHeadHeightOffPlatform])
    cylinder(h = Hh, r = sHeadR);  

}


// Cylinder + thumbhook platform, to be subtracted from hookBase.    
module cylinderPlatformSubtractor() {
    instrumentCylinder();
    // Position the platform on the instrument cylinder.
    // Verticle space from top of platform to keypad guard (F#).
    verticalSpace = 10;
    translate([cr1 - (Ph / 2), -Pw2, cheight - verticalSpace])
    rotate([0, 90, 0])
    platform();
}


module hookBaseWithHook () {
    hookBase();
    
    // Place thumbhook.
    rotate([0, 0, -30])
    translate([10 + thH + cr1 + 1, 0, cheight - 14])
    rotate([85, 0, 180 + 16])
    hook();
}



// The base that fits over the screw hole.
difference() {
   hookBaseWithHook();
   cylinderPlatformSubtractor();
}





