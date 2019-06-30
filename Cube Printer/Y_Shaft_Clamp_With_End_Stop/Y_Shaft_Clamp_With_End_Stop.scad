hole = 1.6/2;
hole_surround = 6/2;
sensor_z = 22;
sensor_y = 48;
sensor_x1 = 10;
sensor_x2 = 20;

$fn=100;
module m(){
    intersection(){
        translate([40, 18, 20.07]) { 
            rotate([0, 180, 0]) {
                translate([-65.25, -195, -40]) {
                    import("Y_Shaft_Clamp_3.stl"); 
                }
            }
        } 

        translate([11, 0, 10]) {
            cube([8,20,9.5]);
        }  
    }
}

module m2(){
    translate([-65.25, -175, -40]) {
        import("Y_Shaft_Clamp_3.stl"); 
    } 

    translate([0, 18, 0]) scale([1, 1.8, 1]) m();

    translate([11, 20, 0])cube([5,30.5,10]);


    translate([sensor_x1, sensor_y, 11]) cylinder(r=hole_surround, h=sensor_z, center=true);
    translate([sensor_x2, sensor_y, 11]) cylinder(r=hole_surround, h=sensor_z, center=true);
    translate([sensor_x1, sensor_y - hole_surround, 0]) cube([sensor_x2 - sensor_x1,hole_surround * 2,sensor_z]);
}

difference(){
    m2();
     
    translate([sensor_x1, sensor_y, 11]) cylinder(r=hole, h=sensor_z, center=true);
    translate([sensor_x2, sensor_y, 11]) cylinder(r=hole, h=sensor_z, center=true);
}