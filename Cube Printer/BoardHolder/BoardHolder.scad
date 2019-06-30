BoardWo = 95;
BoardWi = 86.3;
BoardDo = 100;
BoardDi = 91.3;

BoardH = 2;
BoardHoleD = 4;


ProfileSz = 20;
PartW = BoardWo+ProfileSz;
PartH = 20;
BaseTickness = 5;
BoardDistance = 15;

HolderScrewD = 5;

columnD = BoardWo-BoardWi;
use <extrusion_profile_20x20_v-slot/extrusion_profile_20x20_v-slot.scad>



$fn = 60;

module board(){
	difference(){
		cube([BoardWo,BoardDo,BoardH],true);
		translate([+BoardWi/2,+BoardDi/2,0]) cylinder(d= BoardHoleD, h = BoardH +0.2, center = true);
		translate([+BoardWi/2,-BoardDi/2,0]) cylinder(d= BoardHoleD, h = BoardH +0.2, center = true);
		translate([-BoardWi/2,+BoardDi/2,0]) cylinder(d= BoardHoleD, h = BoardH +0.2, center = true);
		translate([-BoardWi/2,-BoardDi/2,0]) cylinder(d= BoardHoleD, h = BoardH +0.2, center = true);
	}
}


module _Part(edge = 2){

	
	//base plate
	hull(){
		//profile hold part
		translate([+edge -ProfileSz,0,	+(PartH/2-edge)])rotate([90,0,0])cylinder(r = edge, h = BaseTickness);
		translate([+edge -ProfileSz,0,	-(PartH/2-edge)])rotate([90,0,0])cylinder(r = edge, h = BaseTickness);
		//mid
		translate([+columnD/2,	0,	0])rotate([90,0,0])cylinder(d = ProfileSz, h = BaseTickness);
		//end
		translate([-columnD/2 +BoardWo,	0,	0])rotate([90,0,0])cylinder(d = columnD, h = BaseTickness);
		//translate([-edge +BoardWo,	0,	+(PartH/2-edge)])rotate([90,0,0])cylinder(r = edge, h = BaseTickness);
		//translate([-edge +BoardWo,	0,	-(PartH/2-edge)])rotate([90,0,0])cylinder(r = edge, h = BaseTickness);
	}
	
	//right column
	translate([-columnD/2 +BoardWo,	0,	0])rotate([90,0,0])cylinder(d = columnD, h = BaseTickness+BoardDistance);
	
	//left column
	hull(){
		translate([+columnD/2,	0,	0])rotate([90,0,0])cylinder(d = columnD, h = BaseTickness+BoardDistance);
		
		scale([1,1,ProfileSz/columnD])translate([+columnD/2,	0,	0])rotate([90,0,0])cylinder(d = columnD, h = BaseTickness);
	}


}


module Holes(){	
	//holder screw
	translate([-ProfileSz/2,	0.1, 0])rotate([90,0,0])cylinder(d = HolderScrewD+0.2, h = BaseTickness+0.2);
	//right column
	translate([-columnD/2 +BoardWo,	0.1, 0])rotate([90,0,0])cylinder(d = BoardHoleD+0.2, h = BaseTickness+BoardDistance+0.2);	
	//left column
	translate([+columnD/2,			0.1, 0])rotate([90,0,0])cylinder(d = BoardHoleD+0.2, h = BaseTickness+BoardDistance+0.2);
}

module Part(edge = 2){
	difference(){
		_Part(edge);
		Holes();
	}
	
}

//
Part();


//test
/*
translate([0, 0.1, columnD/2])Part();
translate([0, 0.1, BoardDo-columnD/2])Part();

color("red")rotate([90,0,0])translate([BoardWo/2,BoardDo/2,BoardH/2+BoardDistance+BaseTickness])board();
color("silver")translate([-ProfileSz/2,-ProfileSz/2-BaseTickness,-150])extrusion_profile_20x20_v_slot(size=ProfileSz, height=300);
*/