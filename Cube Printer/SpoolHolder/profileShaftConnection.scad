use <customizable_aluminium_extrusion_plate_brackets.scad>
use <extrusion_profile_20x20_v-slot.scad> 
include <basicshapes.scad>    



   profile_sz = 20;
   holder_width = 6;
module alprofileAndScrewHoles(sz = 20, holder_width = 5){
    
    profile_sz  = sz +0.3;
    hole_len = sz/2 + holder_width + 0.1;

    screw_hole_d = 5 + 0.3;
    screw_head_d = 12+0.5;
    screw_hole_y = 20;
    screw_head_h = 2 + 0.1;
    //rod radius 8/2mm
    //wheel radius 25/2mm
    //rod profile distance 5mm


 
    
    translate([0,0,0])cube([profile_sz,200,profile_sz],center = true);
    //screw holes


    translate([0,+screw_hole_y,0])    rotate([0,90,0])cylinder(d=screw_hole_d, h=hole_len, $fn = 100);
    translate([0,-screw_hole_y,0])    rotate([0,90,0])cylinder(d=screw_hole_d, h=hole_len, $fn = 100);

    translate([hole_len,+screw_hole_y,0])    rotate([0,-90,0])cylinder(d=screw_head_d, h=screw_head_h, $fn = 100);
    translate([hole_len,-screw_hole_y,0])    rotate([0,-90,0])cylinder(d=screw_head_d, h=screw_head_h, $fn = 100);

    cylinder(d=screw_hole_d, h=hole_len,$fn = 100);
    translate([0,0,holder_width + profile_sz/2]){
        
        rotate([0,180,0])cylinder(d=screw_head_d, h=screw_head_h, $fn = 100);
    }    
}

module part(){
d = 20;
dI = 12;
hI = 5;
d_hole = 8.3;


difference(){
    union(){
        //holder 
        //eCube(2*holder_width+profile_sz, 60, profile_sz+2*holder_width,holder_width/2,holder_width/2,holder_width/2);  
        r = 3;
        minkowski() {
            
            a = 60-r;
            b = holder_width+profile_sz/2 -r;
            x = sqrt((a*a)/2);
            intersection(){

                
                cube([2*b, a, 2*b], center = true);
                
                translate([0,0,b])rotate([45,0,0])cube([2*b, x, x], center = true);
            }   
            sphere(r);
        }

        

         
         intersection(){
             translate([0,0,holder_width+profile_sz/2-sqrt(2*d*d)/2])rotate([45,0,0])cube([2*holder_width+profile_sz,d*2,d*2], center=true);
             //cos(45) = x/r             
             x= cos(45) * d/2; 
             translate([0,0,holder_width+profile_sz/2-((d/2+r)/2-x)])rotate([0,0,0])cube([2*holder_width+profile_sz,d*2,d/2+r], center=true);
             //#translate([0,0,holder_width+profile_sz/2-(d/2-x)])rotate([0,0,0])cube([2*holder_width+profile_sz,d*2,d], center=true);
         }
         

         translate([0,0,holder_width+profile_sz/2])rotate([0,90,0])cylinder(d=d, h=2*holder_width+profile_sz, center=true);
         translate([holder_width+profile_sz/2,0,holder_width+profile_sz/2])rotate([0,90,0])cylinder(d1=d, d2 = dI, h=hI);
    }
    rotate([0,-90,0])alprofileAndScrewHoles(profile_sz, holder_width);
     translate([-holder_width-profile_sz/2 - 0.1,0,holder_width+profile_sz/2])rotate([0,90,0])cylinder(d=8.2, h=2*holder_width+profile_sz+0.2+hI);



}
}


part($fn = 100);
/*
module m(){
    translate([-5,-2,0])
intersection(){
rotate([0,0,45])square(3);
square(6);
}
}


minkowski() {
   
    #square(5);
     m();
}
*/