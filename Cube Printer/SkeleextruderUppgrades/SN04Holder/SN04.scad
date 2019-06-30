
SN04_H = 34;
SN04_W = 18;
SN04_L = 18;
SN04_L2 = 13;
SN04_ledD = 3;
SN04_H2 = 18;


    hole_x_pos = 28.5;
    hole_y_pos = (SN04_W -11) /2;
    hole_d = 3.2;
    hole_len = 7+hole_d;

    
//rated distance 4mm
//recomended distance 3.2mm
module SN04_hole(d,w,h){
    translate([-(w/2),0,0]){
        cylinder(d = d, h=h,$fn = 60);
        translate([w-d,0,0])cylinder(d = d, h=h,$fn = 60);
        translate([w/2-d/2,0,h/2])cube(size=[w-d, d, h], center=true);
    }
}

module SN04(){




    angled_side = sqrt(SN04_ledD*SN04_ledD + (SN04_L-SN04_L2)*(SN04_L-SN04_L2));
    angle = atan((SN04_L-SN04_L2)/(SN04_ledD));

    difference(){
        union(){
            cube([SN04_H,SN04_W,SN04_L2]);
            difference(){
                translate([0,0,SN04_L2])cube([SN04_H2+SN04_ledD,SN04_W,SN04_L-SN04_L2]);
                translate([SN04_H2,-0.1,SN04_L])rotate([0,angle,0])cube([angled_side,SN04_W+0.2,2*SN04_ledD]);
            }
        }
        //holes
        translate([hole_x_pos,hole_y_pos,-0.1])SN04_hole(d = hole_d, w = hole_len, h=SN04_L2+0.2);
        translate([hole_x_pos,SN04_L-hole_y_pos,-0.1])SN04_hole(d = hole_d, w = hole_len, h=SN04_L2+0.2);
    }


    //LED is not measured ... not impostand, just to look well
    translate([SN04_H2 + SN04_ledD/2,SN04_W/2,SN04_L2]){
        cylinder(d = 5, h = 1, $fn = 60);
        translate([0,0,1])cylinder(d = 4, h = 1, $fn = 60);
        color("red")translate([0,0,2])sphere(d = 3, $fn = 60);
    }

    //cable is not measured ... not important, just to look well
    color("black"){
        translate([SN04_H,SN04_W/2,SN04_L2/2])rotate([0,90,0])cylinder(d=4, h=1,$fn = 60);
        translate([SN04_H,SN04_W/2,SN04_L2/2])rotate([0,90,0])cylinder(d=3, h=20,$fn = 60);
    }

}


//SN04();
