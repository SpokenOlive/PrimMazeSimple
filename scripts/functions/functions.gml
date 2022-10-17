/*
	A COLLECTION OF BASIC FUNCTIONS I USE A LOT, 
	COLLECTED HERE, SO I DON'T HAVE TO REWRITE 
	THEM IN EVERY NEW PROJECT
*/

#region LOGGING
// ============================================
// GENERAL FUNCTIONS
// ============================================
function LOG(str) {
	show_debug_message(".> " + string(str) + " " + string(current_date_string()));
}

function current_date_string() {
	return "[" + string(current_year) + "/" + string(current_month) + "/" + string(current_day) + " " + string(current_hour) + ":" + string(current_minute) + ":" + string(current_second) + "]";
}
#endregion

#region MATH
// ============================================
// MATH FUNCTIONS
// ============================================
function vec2(xx = 0,yy = 0) constructor {
	x = xx;
	y = yy;
	
	static set = function(xx,yy) {
		x = xx;
		y = yy;
	}
	
	static add = function(vec) {
		if (is_numeric(vec)) {
			return new vec2(x+vec,y+vec);
		}
		else {
			return new vec2(x+vec.x,y+vec.y);
		}
	}
	
	static copy = function() {
		return new vec2(x,y);
	}
	
	static equal_to = function(vec) {
		return (x == vec.x && y == vec.y);
	}
	
	static report = function() {
		return "[x: " + string(x) + ", y: " + string(y) + "]";
	}
}
#endregion

#region CAMERA
// ============================================
// CAMERA FUNCTIONS
// ============================================
function tso_camera() constructor {
	camr = noone;
	zoom = .35;
	bwid = 1366;
	bhig = 768;
	cwid = bwid*zoom;
	chig = bhig*zoom;
	xpos = 0;
	ypos = 0;
	zpos = 0;
	rend = 32000.0;
	proj = matrix_build_projection_ortho(cwid,chig,1.0,rend);
	view = matrix_build_lookat(xpos,ypos,-10,xpos,ypos,zpos,0,1,0);
	left = 0;
	top	 = 0;
	
	function initialize() {
		if (!view_enabled) {
			view_enabled = true;
			view_visible[0] = true;
		}
		
		camr = view_camera[0];
		update_camera(xpos,ypos);
	}
	
	function zoom_camera(amt) {
		zoom = amt;
		cwid = bwid*zoom;
		chig = bhig*zoom;
	}
	
	function update_camera(xx,yy) {
		xpos = xx;
		ypos = yy;
		
		left = xpos - cwid/2;
		top  = ypos - chig/2;
		
		proj = matrix_build_projection_ortho(cwid,chig,1.0,rend);
		view = matrix_build_lookat(xpos,ypos,-10,xpos,ypos,zpos,0,1,0);
		
		camera_set_proj_mat(camr,proj);
		camera_set_view_mat(camr,view);
		camera_apply(camr);
	}
	
	function point_in_view(xx,yy){
		if (point_in_rectangle(xx,yy,left,top,left+cwid,top+chig)) {
			return true;
		}
		return false;
	}
	
	initialize();
}
#endregion
