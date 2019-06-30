include <D:\openscad\_libraries\nutsnbolts-master\cyl_head_bolt.scad>;

z_offset = 6;
hole_diameter = 4.3;


//create thread
ds      = _get_screw("M10x20");
df      = _get_screw_fam("M10x20");
orad    = df[_NB_F_OUTER_DIA]/2;	
lead    = df[_NB_F_LEAD]; 
difference(){
    thread(orad,z_offset,lead);
    translate([0,0,z_offset/2])cylinder(h = z_offset+0.1,d = hole_diameter,center = true, $fn = 100);

}

difference(){
    union(){
        //import base part
        translate([44.04,-(242.47+243.9)/2,-298.5]) import("SP_inlet_std_b4.stl");


        //fill holes
        translate([0,0,8])difference() {
            z = 4;
            cube([hole_diameter,hole_diameter,z],center = true);
            cylinder(h = z+0.1,d = hole_diameter,center = true, $fn = 100);
        }
        translate([0,0,7])difference() {
            z = 3;
            cylinder(h = z, d = 13,center = true, $fn = 100);
            cylinder(h = z+0.1,d = hole_diameter,center = true, $fn = 100);
        }    
    }  


    
    cube_xy = 20;
    cube_z = 12;
    //remobe bottom
    cube([cube_xy,cube_xy,cube_z],center = true);
    
    //remove surounding cylinter
    //for(variable = [start : increment : end])
    for(i = [0 : -45 : -45*5]){
        if (i!=-90) {
            rotate([0,0,i])translate([-17,0,6])    cube([cube_xy,cube_xy,cube_z],center = true);
        }
        
    }
}