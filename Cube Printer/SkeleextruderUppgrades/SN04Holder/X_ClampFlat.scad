//include<SN04.scad>;
include <BasicShapes.scad>

base_x = 28;
base_y = 37.5;
base_z = 10;//8
mid_z = base_z - 2.2;//5.8;//cannot be more ... belt


screw_d = 3.2;
screw_head_d = 5.7;
screw_head_h = 3+0.5;
mid_screw_y = 24.9;

bot_screw_y = 4.1;
bot_screw_x = 10.6;

mid_lock_z = 1.8;


module _screw(h = base_z+0.2){
    translate([0,0,-0.1]) screwHole(head_d = screw_head_d, head_h = screw_head_h, body_d = screw_d, h = h, mount = 0.25, mount_h = 1);
}

module holes(){
    //bearing
    bearing_d = 15.2;
    bearing_h = 24;
    translate([0,15,base_z+2])rotate([0,90,0])cylinder(d=bearing_d, h=bearing_h, center=true);
    translate([0,15,base_z+2])rotate([0,90,0])cylinder(d=bearing_d-4, h=base_x+0.1, center=true);

    //between bearing and belt
    translate([0,23,base_z+0.1])cube([6.5,6,4.2],center = true);

    //belt
    d1= 3;
    d2= 5;
    y1 = 25.5;
    y2 = 32.5;
    translate([0,y1,d1/2+mid_z])rotate([0,90,0])cylinder(d=d1, h=base_x+0.2, center=true);
    translate([0,y1,d1+mid_z])cube([base_x+0.2, d1, d1], center=true);

    translate([0,y2,d2/2+mid_z])rotate([0,90,0])cylinder(d=d2, h=base_x+0.2, center=true);
    
    translate([0,y1+(y2-y1)/2,base_z-(base_z - mid_z-0.1)/2])cube([base_x+0.2, y2-y1, base_z - mid_z+0.1], center=true);

    //bottom
    translate([0,-7,-0.1])cylinder(d=24, h=base_z+0.2);

    //mid screw 
    translate([0,mid_screw_y,0])_screw();
    //translate([0,mid_screw_y,-0.1])cylinder(d=screw_d, h=base_z+mid_lock_z +0.2);

    //bot screws
    translate([bot_screw_x,bot_screw_y,0])_screw();
    translate([-bot_screw_x,bot_screw_y,0])_screw();
}

module base(){

    translate([0,base_y/2,base_z/2])cube([base_x,base_y,base_z],center = true);
    //locks
    lock_x  =10.5;
    lock_y  = base_y-0.9;
    lock_z = 5;
    translate([+lock_x,lock_y,base_z+(lock_z-1)/2])eCube(x = 4.7,y =1.6,z=lock_z+1,cut_x = 0.5,cut_y = 0.5,cut_z = 0.5);
    translate([-lock_x,lock_y,base_z+(lock_z-1)/2])eCube(x = 4.7,y =1.6,z=lock_z+1,cut_x = 0.5,cut_y = 0.5,cut_z = 0.5);
    //mid lock
    
    translate([0,23,base_z+(mid_lock_z)/2])eCube(14,2,mid_lock_z,0,0,0.5);
}

module edges(ed = 1.5){
    translate([-base_x/2,0,0])mirror([0,0,0])Edge(ed, base_z, 0.1);
    translate([+base_x/2,0,0])mirror([1,0,0])Edge(ed, base_z, 0.1);
    translate([-base_x/2,base_y,0])mirror([0,1,0])Edge(ed, base_z, 0.1);
    translate([+base_x/2,base_y,0])mirror([1,1,0])Edge(ed, base_z, 0.1);
}


//debug
/*
translate([40,0,0]){
    translate([60-15.47,-182+0.5,-312]) import("SP__X_clamp_b5b.stl");
    #base();
    //holes();
    edges();
}*/




module part($fn = 20){
    difference(){
        base();
        holes();
        edges();
    }

}

module Connection(){
    hd_h = 10.1;
    hd_d1 = screw_head_d -0.1;
    hd_d2 = hd_d1 +0.5;

    nt_h = hd_h;
    nt_sz1 = 5.5-0.1;
    nt_sz2 = nt_sz1 + 0.5;

    h = base_x + 0.2;

    translate([-h/2,0,0])rotate([30,0,0])rotate([0,90,0])screwNutHole(head_d1 = hd_d1, head_d2 = hd_d2, head_h = hd_h, body_d = screw_d, h = h, mount = 0.25, mount_h = 1, nut_h = nt_h, nut_sz1 = nt_sz1, nut_sz2 = nt_sz2);

}
module LPart($fn = 20){
    difference(){  
        part();
        //screw
        translate([0,33,4])Connection();
        //cut
        translate([0,-0.1,-0.1])cube([50,50,20]);

    }
}

module RPart($fn = 20){
    difference(){  
        part();
        //screw
        translate([0,33,4])Connection();
        //cut
        mirror([1,0,0])translate([0,-0.1,-0.1])cube([50,50,20]);

    }
}
//translate([-10,0,0])LPart();
//translate([+10,0,0])RPart();
//translate([-9,-7,-0.5])rotate([0,180,-90])SN04();
