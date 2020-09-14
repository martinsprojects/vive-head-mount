// All dimensions are in millimeters

$fn = 48;
printgap = 0.4; // filament printing offset

// Parameters here
weld_conn_height = 15;
weld_con_diam = 43;

thick = 6;
height = 30;
length = 90*0.76;
r_hole = (5/2) + printgap; // screw size for distance adjustment slot

loop_connect_thick = 13;
wedge_len = 5;
loop_connect_len = 10;
connect_gap = 2.1+printgap+0.3; // gap between HMD steel loops
hmd_wedge = [[length, 0], [length+wedge_len, 0], [length+wedge_len+1, 0], [length+wedge_len+1, loop_connect_thick], [length+wedge_len, loop_connect_thick], [length, thick]];

screwholes = (3/2)+printgap; // screw size for connection through steel loops on HMD

looprod_diam = (2/2); // thickness of steel loop rods
screw_edgespacing = 5; // 5mm from edge closest to loop
looprod_inside_gap = 4; // for placing screw holes centered

endwiden = looprod_diam+looprod_inside_gap+printgap;

module adjustmentbar(){
	cube([length,thick,height]);
		translate([0,(thick/2),height/2]){
			rotate(90,[1,0,0]){
				cylinder(thick,height/2,height/2,true); // height, bottom radius, top r
			}
		}
}
module extruded_polywedge(){
	linear_extrude(height=height, center=false, convexity=1){
		polygon(points=hmd_wedge, convexity=1);
	}
}
// slot for HMD distance adjustment
module adjust_slot(length, maxdist){
	translate([0,thick/2,height/2]){
		rotate(90,[1,0,0]){
			cylinder(thick*20, r_hole, r_hole, true);
		}
	}
	translate([maxdist*length,thick/2,height/2]){
		rotate(90,[1,0,0]){
			cylinder(thick*20, r_hole, r_hole, true);
		}
	}
	translate([0,-thick/2,(height/2)-r_hole]){
		cube([maxdist*length, thick*2, r_hole*2]);
	}
}
module hmd_fork_connect(){
	translate([length+wedge_len, 0, 0]){
		cube([loop_connect_len, loop_connect_thick, height]); // length of wedge end mount
	}
}
module screw_holes(screw_diam, total_height){
	rotate(90,[1,0,0]){
		cylinder(total_height+10, screw_diam, screw_diam, true);
	}
}
module screw_array(){
	translate([(length+wedge_len+screwholes+looprod_diam+(looprod_inside_gap/2)), loop_connect_thick/2, screwholes+(screw_edgespacing/2)]){
		screw_holes(screw_diam=screwholes, total_height=loop_connect_thick);
		translate([0,0,height-((screwholes*2)+screw_edgespacing)]){
			screw_holes(screw_diam=screwholes, total_height=loop_connect_thick);
		}
	}
}
module weldmount_bracket(){
	translate([0,(thick/2)-1.4,height/2]){
		rotate(90,[1,0,0]){
			cylinder(weld_conn_height, weld_con_diam, weld_con_diam, true);
		}
	}
}
module endjointgap(){
	translate([(length+wedge_len+loop_connect_len-(endwiden)), (loop_connect_thick/2)+(-8/2), -5]){
		cube([endwiden+10, 8, height+10]);
	}
	translate([length+wedge_len, (loop_connect_thick/2)+(-connect_gap/2), -5/2]){
		cube([loop_connect_len+5, connect_gap, height+5]); // 4mm gap in loop, loop rod diameter 2mm
	}
}

difference(){
	difference(){
		union(){
			difference(){
				union(){
					adjustmentbar();
					extruded_polywedge();
					hmd_fork_connect();
				}
				adjust_slot(0.7, length);
			}
		}
		screw_array();
	}
	endjointgap();
}