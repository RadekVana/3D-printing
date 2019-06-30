

use <extrusion_profile_20x20_v-slot.scad>;
use <spool.scad>

profile_sz = 20;
X = 550;
XY_Frame = 600; 

X_Rail_len = X -50;
Y_Rail_len = X_Rail_len;
Z_Rail_len = X_Rail_len;



Z = 650;

Z_Mid = Z_Rail_len ;
half = profile_sz/2;
Z_top_gap = 50;
Z_bot_pos = profile_sz+half+Z_Mid+Z_top_gap;

Rail_Wr = 12;
Rail_Hr	= 8;
//Rail_len = 350;

bed_sz = 300;

motor_xy = 42;
motor_z = 37;



holder_Y = 300;
holder_Z = 150;

module holder(){
	translate([0,0,holder_Z-half])rotate([-90, 0, 0]) extrusion_profile_20x20_v_slot(height=holder_Y);
	translate([0,XY_Frame/2 - half,-profile_sz])rotate([0, 0, 0]) extrusion_profile_20x20_v_slot(height=holder_Z);
}

module motor(){
	color("red")cube([motor_xy,motor_xy,motor_z],center =true);
}

module parallel_p(l, dist,size = 20) {
	translate([-l/2,+(dist/2 + size/2),0])rotate([0,90,0])extrusion_profile_20x20_v_slot(size = size, height=l);
	translate([-l/2,-(dist/2 + size/2),0])rotate([0,90,0])extrusion_profile_20x20_v_slot(size = size, height=l);
}

module simetric_sqr(l1, l2,size = 20){
	
	parallel_p(l1,l2);
	rotate([0,0,90])parallel_p(l2,l1);
}
module asimetric_sqr(l1, l2,size = 20){
	
	parallel_p(l1,l2);
	rotate([0,0,90])parallel_p(l2,l1-2*size);
}


module bed(){
	rotate([0,0,0])parallel_p(XY_Frame,2*profile_sz);
	translate([0,0,profile_sz])rotate([0,0,90])parallel_p(X,bed_sz-2*profile_sz);
	color("yellow")translate([0,0,1.5*profile_sz +3/2 +1])cube([bed_sz,bed_sz,3],center =true);
}

module Rail(l){color("green")
	cube([Rail_Hr, Rail_Wr, l],center = true);

} 

//motors
translate([(XY_Frame/2 - motor_xy/2),(XY_Frame/2 + motor_xy/2 + profile_sz),-motor_z/2])motor();
translate([-(XY_Frame/2 - motor_xy/2),(XY_Frame/2 + motor_xy/2 + profile_sz),-motor_z/2])motor();

translate([(XY_Frame/2 - motor_xy/2-profile_sz),0,-motor_z/2 -Z_bot_pos + half])motor();
translate([-(XY_Frame/2 - motor_xy/2-profile_sz),0,-motor_z/2 -Z_bot_pos + half])motor();


//X RAIL
translate([-X/2,0,-15-half])rotate([0,90,0])extrusion_profile_20x20_v_slot(height=X);//1x X
translate([0,0,-15+Rail_Hr/2])rotate([0,90,0])Rail(X_Rail_len);

//Top part
translate([0,0,-half])asimetric_sqr(XY_Frame,XY_Frame);//4x XY_Frame
translate([0,0,-half-Z_top_gap])parallel_p(XY_Frame,XY_Frame);//2x XY_Frame
translate([0,0,-half-Z_top_gap])rotate([0,0,90])parallel_p(XY_Frame,XY_Frame-2*motor_xy -4*profile_sz);//2x XY_Frame

//Y RAIL 
translate([+(XY_Frame/2 - profile_sz - Rail_Hr/2),0,-half])rotate([90,0,0])Rail(Y_Rail_len);
translate([-(XY_Frame/2 - profile_sz - Rail_Hr/2),0,-half])rotate([90,0,0])Rail(Y_Rail_len);

//Bot part
translate([0,0,-Z_bot_pos])asimetric_sqr(XY_Frame,XY_Frame);//4x XY_Frame
translate([0,0,-Z_bot_pos])rotate([0,0,90])parallel_p(XY_Frame,XY_Frame-2*motor_xy -4*profile_sz);//2x XY_Frame

//"Legs"
translate([+(XY_Frame/2 +half),+(XY_Frame/2 +half),-Z])rotate([0,0,0])extrusion_profile_20x20_v_slot(height=Z);//1x Z
translate([-(XY_Frame/2 +half),+(XY_Frame/2 +half),-Z])rotate([0,0,0])extrusion_profile_20x20_v_slot(height=Z);//1x Z
translate([+(XY_Frame/2 +half),-(XY_Frame/2 +half),-Z])rotate([0,0,0])extrusion_profile_20x20_v_slot(height=Z);//1x Z
translate([-(XY_Frame/2 +half),-(XY_Frame/2 +half),-Z])rotate([0,0,0])extrusion_profile_20x20_v_slot(height=Z);//1x Z

//bed guidence
X_bed_guidence = (XY_Frame/2 +half - 2*profile_sz- motor_xy);
translate([+X_bed_guidence,0,-Z_Mid-profile_sz-Z_top_gap])rotate([0,0,0])extrusion_profile_20x20_v_slot(height=Z_Mid);//1x Z_Mid
translate([-X_bed_guidence,0,-Z_Mid-profile_sz-Z_top_gap])rotate([0,0,0])extrusion_profile_20x20_v_slot(height=Z_Mid);//1x Z_Mid
translate([+X_bed_guidence - profile_sz/2 - Rail_Hr/2,0, -Z_top_gap - Z_Rail_len/2])rotate([0,0,0])Rail(Z_Rail_len);
translate([-(X_bed_guidence - profile_sz/2 - Rail_Hr/2),0, -Z_top_gap - Z_Rail_len/2])rotate([0,0,0])Rail(Z_Rail_len);

//bed
translate([0,0,-200])bed();//2x XY_Frame, 2x X



//spools size is 45
spool_width = 45;
spool_Z = 200;
spool_Y = 100;
translate([-spool_width/2,spool_Y,spool_Z]) rotate([0,90,0]){makePart();};
translate([spool_width + profile_sz - spool_width/2,spool_Y,spool_Z]) rotate([0,90,0]){makePart();};
translate([-spool_width - profile_sz - spool_width/2,spool_Y,spool_Z]) rotate([0,90,0]){makePart();};

translate([-(spool_width/2 + half),0,0])holder();
translate([+(spool_width/2 + half),0,0])holder();
translate([-(1.5*spool_width + 1.5*profile_sz),0,0])holder();
translate([+(1.5*spool_width + 1.5*profile_sz),0,0])holder();
//16x 	XY_Frame 		.. 600 mm
//3x 	X 				.. 550 mm
//4x	Z				.. 650 mm
//2x	Z_Mid			.. 500 mm

//5x Rail Rail_len		.. 500 mm
//+2x extra Rail block

//holder
//4x	150mm
//4x	300mm


