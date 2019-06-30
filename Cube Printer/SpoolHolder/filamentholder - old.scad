use <customizable_aluminium_extrusion_plate_brackets.scad>
use <extrusion_profile_20x20_v-slot.scad> 
include <basicshapes.scad>    






module holder1(len = 100){
    scale([1,1,60.1/60])translate([+10.1,0,0])mirror([0,0,0])rotate([0,90,0])aluminium_extrusion_bracket( shape = "T", support = "full", center = true );
    scale([1,1,60.1/60])translate([-10.1,0,0])mirror([1,0,0])rotate([0,90,0])aluminium_extrusion_bracket( shape = "T", support = "full", center = true );

    color([0/255, 255/255, 0/255]) {
    translate([-10.1,0,20.1])rotate([0,90,0])extrusion_profile_20x20_v_slot(size=20, height=len);
    translate([-10.1,0,40.1])rotate([0,90,0])extrusion_profile_20x20_v_slot(size=20, height=len); 
    }

translate([len/2-10.1,0,30.1])eCube(len,15,15,cut_x = 5,cut_y = 0,cut_z = 0);
}

module holder2(len = 100){
    rotate([180,0,0])aluminium_extrusion_bracket( shape = "T", support = "full", center = true );
    

    color([0/255, 255/255, 0/255]) {
    translate([-10.1 - len,0,10])rotate([0,90,0])extrusion_profile_20x20_v_slot(size=20, height=len);

    }


}





 //holder2(120);
//rotate([90,0,0])extrusion_profile_20x20_v_slot(size=20, height=100);
aluminium_extrusion_bracket( type = "short", shape = "T", support = "full", center = true );