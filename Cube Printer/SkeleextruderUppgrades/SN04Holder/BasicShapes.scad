
//add 0.1 if you need to cut corner
module Edge(r, h, add = 0){
    mirror([1,1,0])translate([-r,-r,0])intersection(){
        translate([0,0,h/2])difference(){
            cube([(r+add)*2,(r+add)*2,h+add*2],center =true);
            cylinder(r = r+add, h = h+0.2 + add*2, center=true);
        }
        translate([0,0,-add])cube([r+add,r+add,h+add*2]);
    }
    

}




//x must be >= y
//solved in MyCube
module _eCube(x,y,z, cut = 0){
    new_len_of_y = y - cut *2;
    new_len_of_x = x/sqrt(2) + new_len_of_y *sqrt(2)/2;
    intersection(){
        cube([x,y,z], center = true);
        rotate([0,0,45]) /*translate([-0,-0,-0])  */ cube([new_len_of_x,new_len_of_x,z+1], center = true);
    }
}

//use intersection if you need more nice edges
module eCube(x,y,z,cut_x = 0,cut_y = 0,cut_z = 0){
    intersection(){
        _eCube(x,y,z, cut_z);//z is normal
        rotate([90,0,0])_eCube(x,z,y, cut_y);//rotate by x will switch y and z 
        rotate([0,90,0])_eCube(z,y,x, cut_x);//rotate by y will switch x and z 
    }
}

module screwHole(head_h = 1, head_d1 = 1, head_d2 = 1, h = 1 , body_d = 1, mount = 0, mount_h = 0,head_d = 0){
    //head
    if(head_d == 0){
        cylinder(d2 = head_d1, d1 = head_d2, h = head_h);
    }else{
        cylinder(d = head_d, h = head_h);
    }
    
    //mount
    translate([0,0,head_h])cylinder(d1 = 2*mount + body_d, d2 = body_d, h = mount_h);
    //body
    cylinder(d = body_d, h = h);
}
/*
module nutHole(sz,h){
    //cos (360/12) = (sz/2)/(d/2)
    cylinder(d = sz/(cos(30)),h=h, $fn = 6); 
}*/
module nutHole(h=1, sz1 = 1, sz2=1, center = false, sz = 0){

    //cos (360/12) = (sz/2)/(d/2)
    if (sz == 0) {
        cylinder(d1 = sz1/(cos(30)),d2 = sz2/(cos(30)),h=h, $fn = 6, center = center); 
    }else{
        cylinder(d = sz/(cos(30)),h=h, $fn = 6, center = center); 
    }
}

module screwNutHole(head_h = 1, head_d1 = 1, head_d2 = 1, h = 1 , body_d = 1, nut_sz1 = 1,nut_sz2 = 1, nut_h = 1, mount=0, mount_h=0, head_d = 0, nut_sz = 0){
    //screw
    screwHole(head_h = head_h, head_d1 = head_d1, head_d2 = head_d2, h = h, body_d = body_d, mount = mount, mount_h = mount_h, head_d = head_d);

    //nut
    translate([0,0,h-nut_h])nutHole(sz1 = nut_sz1, sz2 = nut_sz2, h=nut_h, sz = nut_sz, center = false);

    
    //nut mount
    translate([0,0,h - mount_h - nut_h])cylinder(d2 = 2*mount + body_d, d1 = body_d, h = mount_h);
}

module RotaryButton(h = 1, d = 1, edgesTimes4 = 12, center = false){
    x = edgesTimes4*4;
    module _do(){
        a = sqrt(d*d / 2);
        for (i=[0:360/x:360]) {
            rotate([0,0,i])cube([a,a,h],center = true);
        }
    }
    if(center == true){
        _do();
    }else{
        translate([0,0,h/2])_do();
    }
}

module squareNutHole(nut_h = 1.8+0.1, side = 5.5+0.1, hole_h_up = 1, hole_h_down = 1, hole_d = 3+0.1,mount=0.2, mount_h=0.5,$fn = 50){
    cube(size=[side, side, nut_h], center=true);
    translate([0,0,-nut_h/2-hole_h_down])cylinder(d = hole_d, h = nut_h + hole_h_down + hole_h_up);
    translate([0,0,nut_h/2])cylinder(d1 = mount + hole_d, d2 = hole_d,h = mount_h);
    mirror([0,0,1])translate([0,0,nut_h/2])cylinder(d1 = mount + hole_d, d2 = hole_d,h = mount_h);
}


module frustum(h = 1, x1 = 1, y1 = 1, x2 = 1, y2 = 1, center = false){
    linear_extrude(height = h, scale = [x2/x1,y2/y1])square([x1,y1],center);
}

//do not mistake insert_h for insert_len 
module squareNutHoleWithInsert(nut_h = 1.8+0.1, side = 5.5+0.1, hole_h_up = 1, hole_h_down = 1, hole_d = 3+0.1,mount=0.2, mount_h=0.5, insert_len = 1, extra_insert_h = 1,  extra_insert_side = 1,  $fn = 50){
    squareNutHole(nut_h = nut_h, side = side, hole_h_up = hole_h_up, hole_h_down = hole_h_down, hole_d = hole_d, mount = mount, mount_h = mount_h);
    translate([0,side/2,0])rotate([-90,0,0])frustum(h = insert_len, x1 = side, y1 = nut_h, x2 = extra_insert_side + side, y2 = extra_insert_h + nut_h, center = true);
}
/*
module screwNutHole2(head_d, head_h, body_d, h, nut_sz, nut_h, mount, mount_h){
    screwNutHole(head_d, head_h, body_d, h, nut_sz,nut_sz, nut_h, mount, mount_h);
}*/

//Edge(3, 10, 0.1,$fn = 100);