include <basicshapes.scad>    

  


module part(   
    h = 5,
    d = 20,
    dI = 12,
    hI = 5,
    d_hole = 8.3,
    
    scrHead_d = 13.3,
    scrHead_h = 4){

    difference(){
        union(){
            cylinder(d=d, h=h);
            translate([0,0,h])cylinder(d1=d, d2 = dI, h=hI);
        }

        translate([0,0, - 0.1]){
            cylinder(d=d_hole, h=h+0.2+hI);

            cylinder(d=scrHead_d, h=scrHead_h + 0.1);
        }
    }
}

minkowski($fn = 50){

    part(h = 10-1,
        d = 20-2,
        dI = 12-2,
        hI = 5-1,
        d_hole = 8.3+2,

        scrHead_d = 13.3 +2,
        scrHead_h = 9 -1);
    sphere(r=1);
}
    

//translate([10,0,0])part($fn = 10);
