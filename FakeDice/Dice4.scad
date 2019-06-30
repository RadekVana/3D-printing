

$fn = $preview ?12 : 100;

 
module dira(size = 2){
	difference(){
		cylinder(r = size, h = size/2);
		rotate_extrude(convexity = 10)translate([size, 0, 0]) circle(r = size/2);
	}
	sphere(r = size/2);
} 
 
module diry4(dira_sz = 4,offset = 4, size = 20){

	sz = 0.1 + size / 2 -dira_sz/2;
	module side(){
		translate([+offset,+offset,sz]) dira(dira_sz);
		translate([+offset,-offset,sz]) dira(dira_sz);
		translate([-offset,+offset,sz]) dira(dira_sz);
		translate([-offset,-offset,sz]) dira(dira_sz);
	}
	
	
	
	for(n = [1 : 4]) rotate([n * 90, 0, 0])side();

	rotate([0, 90, 0])side();
	rotate([0, -90, 0])side();
}



module kostka(size = 20, edge = 3){
	sz = size/2 - edge;
	hull(){
	translate([+sz,+sz,+sz])sphere(edge);
	translate([+sz,+sz,-sz])sphere(edge);
	translate([+sz,-sz,+sz])sphere(edge);
	translate([+sz,-sz,-sz])sphere(edge);
	translate([-sz,+sz,+sz])sphere(edge);
	translate([-sz,+sz,-sz])sphere(edge);
	translate([-sz,-sz,+sz])sphere(edge);
	translate([-sz,-sz,-sz])sphere(edge);
	//diry4(r=4,h=3,offset = 4, size = 20);
	}
}

difference()
{
	kostka(20);
	diry4(dira_sz = 4,offset = 4, size = 20);
}



