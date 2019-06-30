include<SN04.scad>;
include <X_ClampFlat.scad>

SCoffset = 8; //to avoid screw
scr_hldr = 10; 

btn_d = 8;
btn_h = 11;
btn_wheel_h = 5;
btn_wheel_d = 20;


//variables for holder
    ed = 1.5;
    L = base_y-SCoffset;
    Z = SN04_L - SN04_L2 + 0.2;
    H = SN04_L+0.1;
    ZR1 = Z - 2;
    ZR2 = 1.1;
    endW = 3;
    
    pocket = 0.3;

    //this hole should be precise
    d_hole = 3;
    end_scale = 0.7;
    
    end_d = btn_d +2;
    end_gap_d = 22;
    end_gap_h = 5.2;
    end_gap_offset = 0.5;
    //rot_btn_lock = btn_h - end_gap_h + 0.3;
    RL_backMount = 9;
    end_h = endW + end_gap_h + end_gap_offset + RL_backMount/2;//rot_btn_lock;




module _Holder(){
    


    module scrH(d,no_ext_h, h, scale)
        {
            translate([0,base_y-endW,-H])rotate([-90,0,0]){
                difference(){
                    scale([base_x/d,1,1])difference(){
                        union(){
                            cylinder(d=d, h=no_ext_h);
                            translate([0,0,no_ext_h])linear_extrude(height = h-no_ext_h,scale = [scale,RL_backMount/d])circle(d=d);

                            translate([0,0,end_h])rotate([0,90,0])cylinder(d=RL_backMount, h=d, center = true);
                        }
                        translate([-(d/2+0.1),-(d/2+0.1),-0.1])cube([d/2+0.1,d+0.2,h+RL_backMount/2+0.2]);
                    }
                    //#translate([0,0,no_ext_h-0.1])cylinder(d=btn_d +0.5, h=rot_btn_lock+0.1);
                }
            
            }    
        }

    color("white"){
    difference(){    
        union(){
            difference(){
                translate([SN04_W/2+0.1,SCoffset,-SN04_L-0.1])cube([(base_x-SN04_W)/2 -0.1,L,H]);
                
                //edges
                translate([base_x/2,base_y,-SN04_L-0.1])mirror([1,1,0])Edge(ed, H, 0.1);
                translate([base_x/2,SCoffset,-SN04_L-0.1])mirror([1,0,0])Edge(ed, H, 0.1);

                //rail

                //+base_y+0.1-endW will create 0.1mm pocket
                translate([SN04_W/2,+base_y+pocket-endW,-SN04_L2])rotate([0,90,-90])carriageRail(L +pocket+0.1-endW,ZR1,ZR2,2.1);
                //translate([SN04_W/2,+base_y+0.1,-SN04_L2])rotate([0,90,-90])carriageRail(L +0.2,ZR1,ZR2,2.1);


            }
            //end part
            translate([0,base_y - endW,-SN04_L-0.1]){
                difference(){
                    cube([(SN04_W)/2 +0.1,endW,H]);
                    translate([0,endW+0.1,SN04_L-SN04_L2/2+0.1])rotate([90,0,0])cylinder(d=5, h=endW+0.2);
                }
            }
            //screw holder
            scrH(end_d,end_gap_offset+end_gap_h+endW,end_h,end_scale);
        }
        
        //end hole
        translate([0,base_y-endW - 0.1,-H])rotate([-90,0,0])cylinder(d=/*d_hole*/btn_d +0.5, h=endW + end_gap_offset +0.2);
        //end gap
        translate([0,base_y + 0.5,-H])rotate([-90,0,0])cylinder(d=end_gap_d, h=end_gap_h);
    }    

    }
}

module LHolder(){
    difference(){
        mirror([1,0,0])_Holder();
        translate([0,base_y-endW+end_h,-H])Connection();
    }
}
module RHolder(){
    difference(){
        _Holder();
        translate([0,base_y-endW+end_h,-H])Connection();
    }
}

module carriageRail(h,a2,a1,w){
    alpha = atan(((a2-a1)/2)/w);
    b = sqrt(pow((a2-a1)/2,2)+pow(w,2));

    difference(){
        cube([a2,w,h]);
        translate([0,0,-0.1])rotate([0,0,90-alpha])cube([b,b,h+0.2]); 
        translate([a2,0,-0.1])rotate([0,0,alpha])cube([b,b,h+0.2]); 
    }
}


module SN04_lock(h = 10, scale = 0.5, d = 3.2, dist = 7, $fn = 50){
 linear_extrude(height = h, convexity = 10, scale=scale){
     translate([0,-dist/2,0])circle(d = d);
     translate([0,+dist/2,0])circle(d = d);
     square(size=[d,dist], center=true);
 }
}


module carriage(){
    X = SN04_W;
    Y = 15;
    Z = SN04_L - SN04_L2;
    ZR1 = Z - 2;
    ZR2 = 1;
    LED_hole = 8;
    
    //screw mount
     
    h =  Y-LED_hole/2;

    hd_h = 3+LED_hole/2;
    hd_d1 = screw_head_d -0.1;
    hd_d2 = hd_d1 +0.5;

    nt_h = 2;
    nt_sz1 = 5.5-0.1;
    nt_sz2 = nt_sz1 + 0.3;

    difference(){
        union(){
            //main cube
            translate([-X/2,0,0])cube([X,Y,Z]);
            //screw mount
            translate([0,LED_hole/2,scr_hldr/2])rotate([-90,0,0]){
                cylinder(d = scr_hldr, h = h);    
            }
        }
        
        translate([0,0,-0.2])cylinder(d=LED_hole, h=Z + 0.3); 
        translate([0,0.1,scr_hldr/2])rotate([-90,0,0]){
            screwNutHole(head_d1 = hd_d1, head_d2 = hd_d2, head_h = hd_h, body_d = screw_d, h = Y+0.1, mount = 0.25, mount_h = 1, nut_h = nt_h, nut_sz1 = nt_sz1, nut_sz2 = nt_sz2);
        } 
    }


    module Rail(){
        translate([-X/2,0,ZR1])rotate([0,90,90])carriageRail(Y,ZR1,ZR2,2);
    }

    Rail();
    mirror([1,0,0])Rail();

    lckX = SN04_L/2-hole_y_pos;
    lckY = 5.9;
    translate([-lckX,lckY,0])mirror([0,0,1])SN04_lock();
    translate([+lckX,lckY,0])mirror([0,0,1])SN04_lock();
} 

module carriage2(){
    X = SN04_W;
    Y = 15;
    Z = SN04_L - SN04_L2;
    ZR1 = Z - 2;
    ZR2 = 1;
    LED_hole = 8;
    
    //screw mount
     
    h =  Y-LED_hole/2;

    hd_h = 3+LED_hole/2;
    hd_d1 = screw_head_d -0.1;
    hd_d2 = hd_d1 +0.5;

    nt_h = 2;
    nt_sz = 5.5+0.1;
    insert_len = scr_hldr/2 - nt_sz/2 + 0.1;

    difference(){
        union(){
            //main cube
            translate([-X/2,0,0])cube([X,Y,Z]);
            //screw mount
            translate([0,LED_hole/2,scr_hldr/2])rotate([-90,0,0]){
                cylinder(d = scr_hldr, h = h);    
            }
        }
        
        translate([0,0,-0.2])cylinder(d=LED_hole, h=Z + 0.3); 
        translate([0,h,scr_hldr/2])rotate([-90,0,0]){
           squareNutHoleWithInsert(nut_h = nt_h ,side = nt_sz, insert_len = insert_len,  hole_h_up = h, hole_h_down = h);
        } 
    }


    module Rail(){
        translate([-X/2,0,ZR1])rotate([0,90,90])carriageRail(Y,ZR1,ZR2,2);
    }

    Rail();
    mirror([1,0,0])Rail();

    lckX = SN04_L/2-hole_y_pos;
    lckY = 5.9;
    translate([-lckX,lckY,0])mirror([0,0,1])SN04_lock();
    translate([+lckX,lckY,0])mirror([0,0,1])SN04_lock();
 
}

//mirrored screw
module _rotBtn($fn = 50){
    d = btn_d;
    h = btn_h;//entire h
    wheel_h = 5;//h of edhed part
    wheel_d = 20;
    edges_tm4 = 11;
    difference(){
        union(){
            cylinder(d=d, h=h);
            RotaryButton(wheel_h,wheel_d,edges_tm4); 
        }
        translate([0,0,0.1+h])mirror([0,0,1])screwNutHole(head_h = 3.1, head_d1 = 5.7, head_d2 = 5.9, h = h+0.2 , body_d = 3.2, nut_sz1 = 5.5+0.2,nut_sz2 = 5.5+0.3, nut_h = 2.1, mount=0.5, mount_h=0.6);
    }
    
}

module rotBtn($fn = 50){
    d = btn_d;
    h = btn_h;//entire h
    wheel_h = btn_wheel_h;//h of edhed part
    wheel_d = btn_wheel_d;
    edges_tm4 = 11;
    difference(){
        union(){
            cylinder(d=d, h=h);
            RotaryButton(wheel_h,wheel_d,edges_tm4); 
        }
        translate([0,0,-0.1])screwNutHole(head_h = 3.1, head_d1 = 5.7, head_d2 = 5.9, h = h+0.2 , body_d = 3.2, nut_sz1 = 5.5+0.2,nut_sz2 = 5.5+0.3, nut_h = 2.1, mount=0.5, mount_h=0.6);
    }
    
}

// part
//RHolder($fn = 50);
//color("white")RPart();
LHolder($fn = 50);
color("white")LPart();

//translate([-9,-7,0])rotate([0,180,-90])SN04();


//translate([0,SN04_H2-9+5,-SN04_L2-0.1])mirror([0,0,1])color("blue")carriage2($fn = 50);


//color("yellow")translate([0,base_y+0.6 +btn_wheel_h,-(SN04_L+0.1)])mirror([0,1,0])rotate([-90,0,0])rotBtn();

//screwNutHole(head_h = 3.1, head_d1 = 5.7, head_d2 = 5.9, h = 11+0.2 , body_d = 3.2, nut_sz1 = 5.5+0.2,nut_sz2 = 5.5+0.3, nut_h = 2.1, mount=0.5, mount_h=0.6,$fn = 50);


