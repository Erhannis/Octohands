/**
Run get_deps.sh to clone dependencies into a linked folder in your home directory.
*/

use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/BOSL/joiners.scad>
use <deps.link/BOSL/shapes.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/erhannisScad/auto_lid.scad>
use <deps.link/scadFluidics/common.scad>
use <deps.link/quickfitPlate/blank_plate.scad>
use <deps.link/getriebe/Getriebe.scad>
use <deps.link/gearbox/gearbox.scad>

$FOREVER = 1000;
DUMMY = false;
$fn = DUMMY ? 10 : 60;

/*
So there's two contraptions.

1. The thing that keeps the skeleton rigid.
Hollow bones, with a wire pulling down the center,
pulling the balls into the sockets?
Squeezing a lever loosens tension - wire wound around spring spool?
Possibly cam spool, for increased force near end of travel?

2: The thing that sets the grip strength.
Probably has springs from hand grip to object grabbers,
and you lock the hand grip in place once you're happy with
the force.
OTOH, can we also have high rigidity?
A second, lightly springloaded set of...something, that push
right up against the object grabbers, and when the hand grip
locks so do they?

*/

BALL_OD = 20;
ANGLE = 60;
BALL_ADHESION_CUT_H = 0.6;

CUP_T = 4;
CUP_EDGE_H = 2;
CUP_GRIP_SCALE = 1.1;

BONE_L = 60;
BONE_OD = 10;
BONE_ID = 3;

SLOP = 0.1;

// Ball
/*intersection() {
    sphere(d=BALL_OD);
    DONUT_OD = (BALL_OD-BONE_ID);
    tz(DONUT_OD/2) rotate_extrude() {
        tx(DONUT_OD/2 + BONE_ID/2) circle(d=DONUT_OD);
    }
}*/
difference() {
    sphere(d=BALL_OD);
    tz(-BALL_OD/2) cylinder(d1=2*(BALL_OD/2)*tan(ANGLE), d2=0, h=BALL_OD/2);
    cylinder(d=BONE_ID,h=$FOREVER,center=true);    
    OZm([0,0,(-BALL_OD/2)*cos(ANGLE)+BALL_ADHESION_CUT_H]);
    //OXp();
}


difference() {
    // Bone
    difference() {
        cylinder(d=BONE_OD,h=BONE_L);
        cylinder(d=BONE_ID,h=$FOREVER,center=true);
    }
    
    // (Remove cup hollow)
    tz(BONE_L) scale([1,1,CUP_GRIP_SCALE]) sphere(d=BALL_OD+SLOP*2);
}

// Cup
tz(BONE_L) difference() {
    scale([1,1,CUP_GRIP_SCALE]) sphere(d=BALL_OD+CUP_T*2);
    scale([1,1,CUP_GRIP_SCALE]) sphere(d=BALL_OD+SLOP*2);
    OZp([0,0,CUP_EDGE_H]);
    cylinder(d=BONE_ID,h=$FOREVER,center=true);
    //OXm();
}