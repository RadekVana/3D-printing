use <customizable_aluminium_extrusion_plate_brackets.scad>
use <extrusion_profile_20x20_v-slot.scad> 
include <basicshapes.scad>  

//#translate([-471.57,0,-2])import ("Spool Bolt.stl");

include <nutsnbolts-master/cyl_head_bolt.scad>;

module holder2(len = 100){
    rotate([180,0,0])aluminium_extrusion_bracket( shape = "T", support = "full", center = true );
    

    color([0/255, 255/255, 0/255]) {
    translate([-10.1 - len,0,10])rotate([0,90,0])extrusion_profile_20x20_v_slot(size=20, height=len);

    }


}

//15.85
module halfSpoolBoltHole(h, inner_d = 15, edgeAngle = 45, gap = 5, materialSaveing_d = 24, bearing_d1 = 22.8, bearing_d2 = 22.3, bearing_h = 7.3){

    
    //calculated variables 
    //tan(alpha) =  ((bearing_d2 - inner_d)/2)/X
    bearingEdge_h = ((bearing_d2 - inner_d)/2) / tan(edgeAngle);
    materialSaveingEdge_h = ((materialSaveing_d - inner_d)/2) / tan(edgeAngle);
    materialSaveingOffset = bearing_h + gap + bearingEdge_h + materialSaveingEdge_h;

    cylinder(d = inner_d,h=h);
    cylinder(d1 = bearing_d1, d2 = bearing_d2, h=bearing_h);
    translate([0,0,bearing_h])cylinder(d1 = bearing_d2, d2 = inner_d, h=bearingEdge_h);
    translate([0,0,bearing_h + gap + bearingEdge_h])cylinder(d1 = inner_d, d2 = materialSaveing_d, h=materialSaveingEdge_h);
    translate([0,0,materialSaveingOffset])cylinder(d = materialSaveing_d,h=h-materialSaveingOffset);
    

}

//hole for 22x7 bearing
module SpoolBoltHole(h = 100, bearing_outer_distance = 100,  inner_d = 15, edgeAngle = 45, gap = 5, materialSaveing_d = 24, bearing_d1 = 22.8, bearing_d2 = 22.3, bearing_h = 7.3){
    

    halfSpoolBoltHole(bearing_outer_distance/2+0.1, inner_d, edgeAngle, gap, materialSaveing_d);
    translate([0, 0, bearing_outer_distance]) mirror([0, 0, 1]) halfSpoolBoltHole(bearing_outer_distance/2+0.1, inner_d, edgeAngle, gap, materialSaveing_d);
    translate([0, 0, bearing_outer_distance]) cylinder(d1=bearing_d1, d2=materialSaveing_d,h=h-bearing_outer_distance);

    
}




module Handle(h = 5, d = 85,count = 10, cut_d = 33){
    //need to know tangent of cut circles = distance fom center
    angle = 360 / count;
    //sin(angle/2) = (cut_d/2)/tangent
    tangent = (cut_d/2)/sin(angle/2);

    difference(){
        cylinder(d=d, h=h);
        //
        for (i=[angle:angle:360]) {
            rotate([0,0,i])translate([tangent,0,-0.1])cylinder(d=cut_d, h=h+0.2);
        }

        

    }
    


}


module _SpoolBolt(h = 130, d1 = 70, d2 = 36, handle_h = 5, midAngle = 40, theat_fill_d = 31, theat_cut_d = 36,theat_orad = 19, theat_lead = 4){
    mid_h = ((d1 - d2)/2) / tan(midAngle);
    Handle(h =handle_h);
    
    translate([0,0,handle_h])cylinder(d1 = d1, d2 = d2, h=mid_h);

    //threat
    translate([0,0,handle_h+mid_h]){
        cylinder(d = theat_fill_d, h=mid_h);
        intersection(){
            len = h - handle_h -mid_h;
            cylinder(d = theat_cut_d, h=len);
            thread(theat_orad, len, theat_lead);
        }
    }
}


module materialSaveing( base_h = 5, do1 = 55,do2 = 35.4, di = 35, angle = 40){

    //tan(angle) = ((do-di)/2)/h
    h =  ((do1-do2)/2)/tan(angle);

    
    
    difference(){
        union(){
            translate([0,0,base_h])cylinder(d1=do1, d2=do2, h = h);
            cylinder(d=do1, h = base_h);
        }
        
        translate([0,0,-0.1])cylinder(d=di, h = h+base_h+0.2);
    }
    
} 


module SpoolBolt(h = 130, bearing_outer_distance = 100, d1 = 70, d2 = 36, handle_h = 5, midAngle = 40, theat_fill_d = 31, theat_cut_d = 36,theat_orad = 19, theat_lead = 4){
    difference(){
        _SpoolBolt(h, d1, d2, handle_h, midAngle, theat_fill_d, theat_cut_d,theat_orad, theat_lead);
        translate([0,0,-0.1])SpoolBoltHole(h + 0.2, bearing_outer_distance = 100);//, inner_d = 15, edgeAngle = 45, gap = 5, materialSaveing_d = 24);
        translate([0,0,-0.1])materialSaveing(base_h = 5+0.2, do1 = 55,do2 = 35.4, di = 35, angle = midAngle);

            //remove bug
    //translate([0, 0, h])cylinder(d=24, h=0.2, center=true);
    }
}


total_h = 150;
nut_h = 6;
profile = 20;
holder_h = 5;

h= total_h - 
nut_h * 4 -
 profile -
  holder_h;
echo(str("Variable = ", h));//101

/*difference(){
SpoolBolt();
cube(200);
}*/

SpoolBolt(h = 140, bearing_outer_distance = 90);

