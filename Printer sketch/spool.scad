//
// Cutomizable Printable Spool
//
// Initial version: V1.0 by Physicator, Oct/2018
//
// Licensed under the Creative Commons - Attribution - Non-Commercial license. 
//
// Note: this design does not work properly in Makerbot's Customizer on Thingiverse. Use the integrated customizer in OpenSCAD instead (tested with version 2018.09.05).
//
// This is a remix of thing #7980 by MakeALot: https://www.thingiverse.com/thing:7980
// A related thing with variable width is #102270 by ksaathoff: https://www.thingiverse.com/thing:102270
//
// This design uses a very similar geometry but offers several cutomizable options and additional features.
//
//
// General naming conventions:
// "core" is the center part of the spool, may also be called "drum center".
// "arm" is a connecting piece between the core and an "edge".
// "edge" is one segment of the circular wall, defining the spool's outer diameter.
// "dovetail" is the structure element for connecting different parts. It is a triangular prism with chamfers.
// "top" and "bottom" refer to positive / negative z-directions, respectively, parallel to the spool axis.
//
// Parameters:
// Note: parameters are NOT fool-proof, so reasonable values must be chosen!
//

/* [General] */

// Select part to be generated. Usually you should only need "core" (1x), "setOfArms" (2x), and "setOfEdges" (2x).
part = "spool"; // [core:Core, arm:Arm, edge:Edge, setOfArms:Set of 8 Arms, setOfEdges:Set of 8 Edges, spool:Complete Spool, explodedSpool:Exploded View]

// Total height of spool. All dimensions in mm!
spoolHeight = 45; // [20:0.5:120]

// Inner radius of spool (circumcircle of inner mounting hole).
innerRadius = 18; // [10:0.2:40]

// Outer radius of core (circumcircle). Also affects dimensions of some elements of arms.
outerCoreRadius = 40; // [15:0.5:100]

// Outer radius of spool. Also affects dimensions of some elements of arms.
outerEdgeRadius = 85; // [30:0.5:170]

// Gap size between mounting structures (increase for easier fit, decrease for tighter fit).
gap = 0.2; // [0:0.02:0.5]
/* Gaps are applied on all sides (but not top and bottom) of mounts; and 50/50 to both 'male' and 'female' structures. */

/* [Core] */

// Set this to "true" for enabling wall cut-outs.
wallCutouts = "true"; // [true, false]

// Number of edges of inner hole. Lower numbers may prevent uncontrolled spool rotation during print (acts like a brake).
innerSegments = 8; // [4:1:60]

// Radius of recess (counterbore) on one side of the core with larger diameter than innerRadius.
topRecessRadius = 30; // [10:0.2:80]

// Depth of recess (counterbore).
topRecessDepth = 0; // [0:0.2:25]

/* Option for filament holes in the spool core. The more holes are involved the more additional space is needed such that wall cut-outs will be smaller (if enabled).
    // all: holes at top and bottom in the middle of edges and at corners
    // corner: holes at top and bottom at corners.
    // cornerTop: holes at top at corners; bottom is cou out as far as possible.
    // cornerTop2: like cornerTop but keeps some material at bottom just above
    //      dovetail cut-outs for sturdier arm mounts.
    // none: no holes at all in the core. Otherwise same as cornerTop2.*/
// Option for filament holes in the spool core. The more holes are involved the more additional space is needed such that wall cut-outs will be smaller (if enabled).
coreHoles = "cornerTop2"; // [all, corner, cornerTop, cornerTop2, none]

// Diameter of holes in core for filament.
holeDiameter = 2.2; // [0:0.1:8]

// Maximum bridge length. This is the maximum length of the top roof of wall cut-outs in the core. Decrease this value if your printer doesn't like bridges, set to zero for no bridge ('pitched roof'). Only relevant if wall cutouts are enabled.
bridgeLength = 10; // [0:0.5:50]


/* [Arms] */

// Thickness of arms. Also affects dimensions of some elements of the core.
armThickness = 4; // [1:0.2:10]

// Width of arms.
armWidth = 4; // [1:0.2:15]

// Chamfer size on bottom plane of dovetail for easier assembly. Also affects chamfers on dovetails of edge elements.
dovetailChamfer = 0.4; // [0:0.1:1]

/* [Edges] */

// Thickness of edges. Should not be larger than armThickness. Also affects dimensions of some elements of the core.
edgeThickness = 3; // [1:0.2:10]

// Edge width, i.e. difference between outer and inner radius of edges. Also affects dimensions of some elements of arms.
edgeWidth = 8; // [3:0.2:30]

// Number of holes in each edge.
edgeHoles = 2; // [0:1:5]

// Diameter of filament holes through edges.
edgeHoleDiameter = 2.4; // [0:0.1:8]

// Option for applying a larger hole diameter at the surface of edges for easier filament insertion. May be restricted to one side of the edges for easier printing.
largeEdgeHoles = "both"; // [both, single, none]

// Diameter of filament holes at the surface of edges. Make this larger than edgeHoleDiameter for easier filament insertion.
outerEdgeHoleDiameter = 5; // [0:0.1:16]

// Elliptical instead of circular holes in the edges for easier filament insertion. The hole diameter along edge direction is multiplied by this factor. Use 1 for circular holes.
lengthyEdgeHoles = 3; // [1:0.1:6]


/* [Colors] */

// Color appearance of core, just for display. Does not affect .stl file. For valid color names see: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#color
coreColor = "Gold";

// Color appearance of arms, just for display.
armColor = "Red";

// Color appearance of edges, just for display.
edgeColor = "DarkGreen";


/* [Hidden] */

// Derived parameters (better do not change):
triGap = gap * sqrt(3); // half of side length change of dovetail triangles due to gap
centerDist = outerCoreRadius * cos(22.5); // distance between origin and the middle of one edge of core polygon. Equivalent to distance of arm from origin (without mounting structures).
dtWidthEdges = edgeWidth * 9 / 16; // side length of dovetail mounts for edges.
sectorAngle = asin(edgeWidth / 2 / (outerEdgeRadius - edgeWidth / 2)); // half-angle of ring sector at the end of arms for connection to edges.
coreEdgeLength = 2 * outerCoreRadius * sin(22.5); // length of outer straight edge of core.
dovetailWidth = coreEdgeLength/2; // Length of dovetail mounting structures between core and arms. Also affects dimensions of some elements of the core.

// 2D shape of a circular sector.
// Taken from module donutSlice() from 2Dshapes.scad in the MCAD directory.
module pieSlice(size, start_angle, end_angle) //size in radius(es)
{	
    rx = ((len(size) > 1)? size[0] : size);
    ry = ((len(size) > 1)? size[1] : size);
    trx = rx* sqrt(2) + 1;
    try = ry* sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if(end_angle > start_angle)
        intersection() {
		if(len(size) > 1)
        	ellipse(rx*2,ry*2);
		else
			circle(r = rx, $fn = 120);
        polygon([
            [0,0],
            [trx * cos(a0), try * sin(a0)],
            [trx * cos(a1), try * sin(a1)],
            [trx * cos(a2), try * sin(a2)],
            [trx * cos(a3), try * sin(a3)],
            [trx * cos(a4), try * sin(a4)],
            [0,0]
       ]);
    }
}

// Arc of a cylindrical ring with rectangular cross section.
// Adapted from module donutSlice() from 2Dshapes.scad in the MCAD directory.
module ringSector(innerSize, outerSize, startAngle, endAngle, height) 
{   
    linear_extrude(height = height, center = false, convexity = 6)
        difference()
        {
            pieSlice(outerSize, startAngle, endAngle);
            circle(innerSize, $fn = 120);
        }
}

// Dovetail mounting geometry (triangular prism with chamfers).
// h = height, l = length, c = chamfer size.
module dovetail(h, l, c) {
    d = l * sqrt(3) / 2; // l along x-direction
    if(c > 0)
        polyhedron(
            points = [[2*c,0,0],[d-c,-l/2+c*sqrt(3),0],[d-c,l/2-c*sqrt(3),0], // bottom triangle
                        [0,0,c],[d,-l/2,c],[d,l/2,c], // triangle on bottom chamfer plane
                        [0,0,h-c],[d,-l/2,h-c],[d,l/2,h-c], // triangle on top chamfer plane
                        [2*c,0,h],[d-c,-l/2+c*sqrt(3),h],[d-c,l/2-c*sqrt(3),h]], // top triangle
            faces = [[0,1,2],[3,4,1,0],[4,5,2,1],[5,3,0,2], // bottom with chamfers
                        [6,7,4,3],[7,8,5,4],[8,6,3,5], // sides
                        [9,10,7,6],[10,11,8,7],[11,9,6,8],[11,10,9]]); // top with chamfers
    else
        polyhedron(
            points = [[0,0,0], [d,-l/2,0], [d,l/2,0], // bottom triangle
                    [0,0,h], [d,-l/2,h], [d,l/2,h]], // top triangle
            faces = [[0,1,2],[3,5,4],[0,3,4,1],[1,4,5,2],[2,5,3,0]]);
}

// Polyhedron for wall cut-outs (if enabled).
// This is a geometry similar to a pyramid.
// l = length, w = width, h = height (prior to rotation!).
// b = bridge length (see also parameter bridgeLength).
module cutoutBody(l, w, h, b) {
    d = (b < w) ? (w - b) / 2 : 0; // distance between outer and inner edges
    translate([h+0.1,0,l/2])
        rotate([0,-90,0])
            polyhedron(
                points = [[-l/2,-w/2,0],[-l/2,w/2,0],[l/2-d,-w/2,0],[l/2-d,w/2,0],[l/2,-w/2+d,0],[l/2,w/2-d,0], // base polygon
                    [-l/2,0,h],[l/2,0,h]], // top points
                faces = [[0,2,4,5,3,1],[0,6,7,2],[3,7,6,1],[0,1,6],[2,7,4],[5,7,3],[4,7,5]]);
}

// Inner part (core) of spool.
module core() {
    // Margin on top and bottom to allow for sufficient space for center holes:
    topBottomMargin = coreHoles == "all" ? max(edgeThickness, armThickness) : edgeThickness;
    // Calculation of height of filament holes on top side:
    filHoleHeight = topRecessDepth > topBottomMargin + 1.5 * holeDiameter ?
        spoolHeight - topBottomMargin - holeDiameter :
        spoolHeight - max(topRecessDepth + holeDiameter, topBottomMargin + holeDiameter);
    // z-position of lower edge of wall cut-outs:
    cutoutBottom = coreHoles == "cornerTop" ? (topBottomMargin) : (
        (coreHoles == "cornerTop2") || (coreHoles == "none") ? (
            topBottomMargin * 1.5) : (topBottomMargin + 2 * holeDiameter));
    // Height of wall cut-outs:
    cutoutHeight = coreHoles == "all" ? (
        min(filHoleHeight - holeDiameter, spoolHeight - topRecessDepth - topBottomMargin / 2) - cutoutBottom) : (
            spoolHeight - max(topBottomMargin * 1.5, topRecessDepth + topBottomMargin / 2) - cutoutBottom);
    // Width of wall cut-outs, determining the radial wall thickness:
    cutoutWidth = coreEdgeLength - 1 - sqrt(armThickness * edgeThickness) * (1 + (spoolHeight / outerCoreRadius) / 4); // weakly scales with a few other parameters, just to keep dimensions somewhhat consistent.
    
	difference() {
        // inner part: 
        rotate([0,0,22.5])
            cylinder(h = spoolHeight, r = outerCoreRadius, $fn=8);
        translate([0,0,-0.1])
            cylinder(h = spoolHeight+0.2, r = innerRadius, $fn = innerSegments);
		if (topRecessDepth > 0)
            translate([0,0,spoolHeight-topRecessDepth])
                cylinder(h = topRecessDepth + .1, r = topRecessRadius, $fn = 64);
        // dovetail cut-outs:
		for (i=[0:7]) {
			rotate([0,0,i*45])
                translate([-centerDist-dovetailWidth/2-gap,0,-0.1])
                    dovetail(edgeThickness + .2, dovetailWidth + triGap, 0);
			rotate([0,0,i*45])
                translate([-centerDist-dovetailWidth/2-gap,0,spoolHeight - edgeThickness])
                    dovetail(edgeThickness + .1, dovetailWidth + triGap, 0);
		}
		// filament holes:
		for (i=[0:3]) {
            // top at corners:
			if (coreHoles != "none")
                rotate([90,0,i*45+22.5])
                    translate([0,filHoleHeight,-outerCoreRadius*1.5]) 
                        cylinder(h = outerCoreRadius * 3, r = holeDiameter/2, $fn = 12);
            // top in the middle of straight sections:
            if (coreHoles == "all")
                rotate([90,0,i*45])
                    translate([0,filHoleHeight,-outerCoreRadius*1.5]) 
                        cylinder(h = outerCoreRadius * 3, r = holeDiameter/2, $fn = 12);
            // bottom:
            if ((coreHoles == "all") || (coreHoles == "corner"))
                rotate([90,0,i*45+22.5])
                    translate([0,edgeThickness+holeDiameter,-outerCoreRadius*1.5]) 
                        cylinder(h = outerCoreRadius * 3, r = holeDiameter/2, $fn = 12);
            if (coreHoles == "all")
                rotate([90,0,i*45])
                    translate([0,edgeThickness+holeDiameter,-outerCoreRadius*1.5]) 
                        cylinder(h = outerCoreRadius * 3, r = holeDiameter/2, $fn = 12);
        }
        // wall cut-outs (if enabled):
        if (wallCutouts == "true")
            for (i=[0:7]) {
                rotate([0,0,i*45])
                    translate([0,0,cutoutBottom])
                        cutoutBody(cutoutHeight, cutoutWidth, centerDist + 0.1, bridgeLength);
            }
	}
}

// A single arm connecting the core and two edges.
module arm() {
    armLength = outerEdgeRadius - centerDist - edgeWidth; // length of arms (without dovetail mounts)
    
    difference() {
        // main arm body and dovetail mount at core side:
        union() {
            // arm bar:
            // In the case of a very large arm width we need to cut out material for avoiding conflicts with edges:
            difference() {
                translate([dovetailWidth/4-0.1,-armWidth/2,0])
                    cube([armLength-dovetailWidth/4+0.2,armWidth,armThickness]);
                translate([-centerDist,0,-0.1]) {
                    ringSector(outerEdgeRadius - edgeWidth - gap, outerEdgeRadius, sectorAngle, sectorAngle + 22.5, armThickness + 0.2);
                    ringSector(outerEdgeRadius - edgeWidth - gap, outerEdgeRadius, -sectorAngle - 22.5, -sectorAngle, armThickness + 0.2);
                }
            }
            // dovetail mount on core side:
            difference() {
                translate([dovetailWidth/2-gap,0,0.001])
                    rotate([0,0,180])
                        dovetail(edgeThickness - 0.002, dovetailWidth - triGap, dovetailChamfer);
                translate([gap+dovetailChamfer+0.1,-dovetailWidth/2-0.1,-0.1])
                    cube([dovetailWidth/2+0.2,dovetailWidth+0.2,edgeThickness+0.2]);
            }
            // counter-bar of dovetail mount on core side, with chamfers:
            translate ([gap/2,0,0])
                rotate([-90,0,0])
                    linear_extrude(height = dovetailWidth, center = true, convexity = 4)
                        polygon(
                            points = [[dovetailChamfer,0],[0,-dovetailChamfer], // upper chamfer
                                [0,-armThickness+dovetailChamfer],[dovetailChamfer,-armThickness], // lower chamfer
                                [dovetailWidth/4,-armThickness],[dovetailWidth/4,0]], // side without chamfers
                            paths = [[0,1,2,3,4,5]], convexity = 4);
            // edge connection body:
            translate([-centerDist,0,0])
                ringSector(outerEdgeRadius - edgeWidth, outerEdgeRadius, -sectorAngle, sectorAngle, armThickness);
        }
        // dovetail cut-outs for mounts of edges:
        translate([-centerDist,0,-0.1]) {
            rotate([0,0,-sectorAngle*0.55])
                translate([outerEdgeRadius-edgeWidth/2,-dtWidthEdges*sqrt(3)/2-gap,0])
                    rotate([0,0,90])
                        dovetail(edgeThickness + 0.101, dtWidthEdges + triGap, 0);
            rotate([0,0,sectorAngle*0.55])
                translate([outerEdgeRadius-edgeWidth/2,dtWidthEdges*sqrt(3)/2+gap,0])
                    rotate([0,0,-90])
                        dovetail(edgeThickness + 0.101, dtWidthEdges + triGap, 0);
        }
    }
}

// All 16 arms, readily positioned around core.
module arms() {
	for (i=[0:7]) {
        rotate([0,0,i*45])
        {
            // arms in lower plane:
            translate([centerDist,0,0])
                arm();
            // arms in upper plane:
            translate([centerDist,0,spoolHeight])
                rotate([180,0,0])
                    arm();
        }
    }
}

// Chamfer geometry for edges (single triangular prism).
module edgeChamferPrism(c, w) {
    polyhedron(
        points = [[-w,0,0],[-w,c,0],[0,c,0],[0,0,0], // top points
            [0,0,-c], [-w,0,-c]], // bottom points
        faces = [[0,1,2,3],[5,4,2,1],[3,4,5,0],[5,1,0],[4,3,2]]);
}

// Two edge chamfer geometries. Need to be rotated and cut out from edges.
module edgeChamfers() {
    // top chamfer:
    translate([outerEdgeRadius+0.1,-0.1,edgeThickness+0.1])
        edgeChamferPrism(dovetailChamfer + 0.2, edgeWidth + 0.2);
    // bottom chamfer:
    translate([outerEdgeRadius+0.1,-0.1,-0.1])
        rotate([90,0,0])
            edgeChamferPrism(dovetailChamfer + 0.2, edgeWidth + 0.2);
}

// A single edge segment.
module edge() {
    // angle of gap opening between arm and edge:
    gapAngle = 2 * asin(gap / 2 / (outerEdgeRadius - edgeWidth / 2));
    // angle between two holes (measured from center of core):
    holeAngle = (edgeHoles <= 1) ? 0 : ((45 - 2 * sectorAngle) / edgeHoles);
    // z-distance between surface of edge and end of larger holes:
    largeHoleZ = largeEdgeHoles == "both" ? edgeThickness * 3 / 8 : (
        largeEdgeHoles == "single" ? edgeThickness * 3 / 4 : 0);
    // radius of circle on which the center points of holes are aligned:
    holeCircleRad = edgeWidth > 2 * max(edgeHoleDiameter, outerEdgeHoleDiameter) ?
        outerEdgeRadius - max(edgeHoleDiameter, outerEdgeHoleDiameter) :
        outerEdgeRadius - edgeWidth / 2;
	difference() {
        union() {
            difference() {
                // main body of edge segment:
                ringSector(outerEdgeRadius - edgeWidth, outerEdgeRadius, sectorAngle + gapAngle, 45 - sectorAngle - gapAngle, edgeThickness);
                // chamfers:
                rotate([0,0,sectorAngle])
                    edgeChamfers();
                rotate([0,0,45-sectorAngle])
                    mirror([0,1,0])
                        edgeChamfers();
            }
            // dovetail mounts:
            rotate([0,0,sectorAngle*0.55])
                translate([outerEdgeRadius-edgeWidth/2,dtWidthEdges*sqrt(3)/2-gap,0.001])
                    rotate([0,0,-90])
                        dovetail(edgeThickness - 0.002, dtWidthEdges - triGap, dovetailChamfer);
            rotate([0,0,45-sectorAngle*0.55])
                translate([outerEdgeRadius-edgeWidth/2,-dtWidthEdges*sqrt(3)/2+gap,0.001])
                    rotate([0,0,90])
                        dovetail(edgeThickness - 0.002, dtWidthEdges - triGap, dovetailChamfer);
        }
        // Filament holes:
        if (edgeHoles > 0) {
            for (i=[0:(edgeHoles-1)]) {
                rotate([0,0,22.5+(i-(edgeHoles-1)/2)*holeAngle]) {
                    if (largeEdgeHoles == "both") {
                        translate([holeCircleRad,0,edgeThickness-largeHoleZ])
                            scale([1,lengthyEdgeHoles,1])
                                cylinder(h = largeHoleZ + 0.1, r1 = edgeHoleDiameter / 2,
                                    r2 = outerEdgeHoleDiameter / 2, $fn = 24);
                    }
                    if ((largeEdgeHoles == "single") || (largeEdgeHoles == "both")) {
                        translate([holeCircleRad,0,-0.1])
                            scale([1,lengthyEdgeHoles,1])
                                cylinder(h = largeHoleZ + 0.1, r1 = outerEdgeHoleDiameter / 2,
                                    r2 = edgeHoleDiameter / 2, $fn = 24);
                    }
                    translate([holeCircleRad,0,-0.1])
                        scale([1,lengthyEdgeHoles,1])
                            cylinder(h = edgeThickness + 0.2, r = edgeHoleDiameter / 2, $fn = 18);
                }
            }
        }
    }
}

// All 16 edges, readily positioned around arms and core.
module edges() {
    for (i=[0:7]) {
        rotate([0,0,i*45])
            edge();
        rotate([0,0,i*45])
            translate([0,0,spoolHeight])
                rotate([0,180,0])
                    edge();
    }
}

// Complete spool (in final arrangment of parts).
module spool() {
    color(coreColor)
        core();
    color(armColor)
        arms();
    color(edgeColor)
        edges();
}

// Exploded view of spool.
module explodedSpool() {
    armDelta = centerDist+dovetailWidth*0.7; // translation distance of arms
    edgeDelta = armDelta - centerDist + edgeWidth; // translation distance of edges
    // Core:
    color(coreColor)
        core();
    // Arms:
    for (i=[0:7]) {
        rotate([0,0,i*45])
        {
            // arms in lower plane:
            translate([armDelta,0,0])
                color(armColor)
                    arm();
            // arms in upper plane:
            translate([armDelta,0,spoolHeight])
                rotate([180,0,0])
                    color(armColor)
                        arm();
        }
    }
    // Edges:
    for (i=[0:7]) {
        rotate([0,0,i*45])
            translate([edgeDelta*cos(22.5),edgeDelta*sin(22.5),0])
                color(edgeColor)
                    edge();
        rotate([0,0,(i+0.5)*45])
            translate([-edgeDelta,0,spoolHeight])
                rotate([0,180,22.5])
                    color(edgeColor)
                        edge();
    }
}

// Set of 8 arms ready for 3D printing.
module setOfArms() {
    for (i=[0:7]) {
        translate([(i%2)*dovetailWidth,(i-3.5)*(armWidth+dovetailWidth/2)+1,0])
            arm();
    }
}

// Set of 8 edges ready for 3D printing.
module setOfEdges() {
    for (i=[0:7]) {
        translate([+outerEdgeRadius-(i-3)*(edgeWidth*1.15+1),0,0])
            rotate([0,180,22.5])
                edge();
    }
}

// Selection of part for Customizer.
module makePart() {
	if (part == "core") {
		color(coreColor)
            core();
	} else if (part == "arm") {
		color(armColor)
            arm();
	} else if (part == "edge") {
		color(edgeColor)
            translate ([outerEdgeRadius-edgeWidth,0,0])
                rotate([0,180,22.5])
                    edge();
    } else if (part == "spool") {
        translate([0,0,0.01]) spool();
    } else if (part == "explodedSpool") {
        explodedSpool();
    } else if (part == "setOfArms") {
        color(armColor)
            setOfArms();
    } else if (part == "setOfEdges") {
        color(edgeColor)
            setOfEdges();
	} else {
		cube(50); // select a valid part or you will be punished by the cube of doom!
	}
}


makePart();

//core();
//arm();
//edge();
//spool();
//explodedSpool();
//setOfArms();
//setOfEdges();