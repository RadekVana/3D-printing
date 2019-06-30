dI=3.2;
dO=6;
h1 = 0.5;
h2 = 1;
h3 = 1.5;
h4 = 2;



module spacer(dO,dI,h){
    difference(){
        cylinder(d = dO, h);
        translate([0,0,-0.1])cylinder(d = dI, h+0.2);

    }
}

translate([0,0,0])spacer(dO,dI,h1,$fn = 100);
translate([dO+1,0,0])spacer(dO,dI,h2,$fn = 100);
translate([0,dO+1,0])spacer(dO,dI,h3,$fn = 100);
translate([dO+1,dO+1,0])spacer(dO,dI,h4,$fn = 100);

