// =========================
// MACROS AND ENUMS
// =========================
#macro BLOCKSIZE		32
#macro HALFSIZE			16
enum dir {
	up,
	right,
	down,
	left
}


// =========================
// HELPER FUNCTIONS
// =========================
#region HELPER FUNCTIONS
// A container object to hold the walls array and
// whether the cell has been visited (i.e. already added to the maze)
function block() constructor {
	visited = false;
	walls	= [true,true,true,true];
}

// Creates an empty grid of blocks (i.e. unvisited cells with four walls)
function empty_grid() {
	for (var i = 0; i < block_grid_wid; i++) {
		for (var j = 0; j < block_grid_hig; j++) {
			block_grid[# i,j] = new block();
		}
	}
}

// Checks if the supplied coord is in the grid or not
function is_valid_coord(vec) {
	if (vec.x < 0 || vec.x >= block_grid_wid || vec.y < 0 || vec.y >= block_grid_hig) {
		return false;
	}
	return true;
}

// This is the master funciton for adding and removing cells to/from the frontier list every loop
function adjust_frontier_list(vec,index) {	
	// CHECK ALL FOUR DIRECTIONS
	var i = 0;
	repeat(4) {
		// if coords are valid and cell is not already visited, try and add it to the frontier
		var check = get_adjacent_cell_coords(vec,i);
		if (is_valid_coord(check)) {
			if (block_grid[# check.x,check.y].visited == false) {
				add_to_frontier(check);
			}
		}
		i++;
	}
	ds_list_delete(frontier_list,index);
}

// This adds the input cell to the frontier if it is not already in the frontier
function add_to_frontier(vec) {
	var in_frontier_already = false;
	var i = 0;
	// look for cell in frontier list
	repeat(ds_list_size(frontier_list)) {
		var check = frontier_list[| i];
		if (check.equal_to(vec)) {
			// if the cell is already in the frontier, then skip this cell
			return;
		}
		i++;
	}
	
	// else, add the cell to the frontier list
	ds_list_add(frontier_list,vec);
}

// This is used to get the opposite wall of a cell based on the input direction
function get_opposite_dir(_dir) {
	// GET OPPOSITE OF INPUT DIRECTION
	if (_dir == dir.up)		return dir.down;
	if (_dir == dir.down)	return dir.up;
	if (_dir == dir.right)	return dir.left;
	if (_dir == dir.left)	return dir.right;
}

// This gets a cell in the of the cardinal directions
function get_adjacent_cell_coords(vec,_dir) {
	// GET CELL IN DIRECTION
	var adjacent = new vec2();
	if (_dir == dir.up)			{ adjacent.set(0,-1); }
	else if (_dir == dir.right) { adjacent.set(1,0); }
	else if (_dir == dir.down)	{ adjacent.set(0,1); }
	else if (_dir == dir.left)	{ adjacent.set(-1,0); }
	return vec.add(adjacent);
}
#endregion


// =========================
// SETUP GRID
// =========================
// Setup basic grid
block_grid_wid	= 8;
block_grid_hig	= 8;
block_grid		= ds_grid_create(block_grid_wid,block_grid_hig);
frontier_list	= ds_list_create();
empty_grid();


// =========================
// PLOT THE MAZE
// =========================
// Plot the maze until we run out of frontier cells (i.e. the grid is full)
do {
	// if the frontier list is empty, this is the first cell, so pick it at 
	// random and add it to the frontier, then loop as normal
	if (ds_list_size(frontier_list) == 0) {
		cur_cell	= new vec2(irandom(block_grid_wid-1),irandom(block_grid_hig-1));
		block_grid[# cur_cell.x,cur_cell.y].visited = true;
		add_to_frontier(cur_cell);
		adjust_frontier_list(cur_cell,0);
	}
	
	// get a random cell in the frontier and visit it
	var index	= ds_list_size(frontier_list)-1;
	cur_cell	= frontier_list[| index];
	block_grid[# cur_cell.x,cur_cell.y].visited = true;
	
	// Create a list of directions and randomize it. We'll use this list 
	// to check for connections and this way it won't be a predictable list
	var dirs = ds_list_create();
	ds_list_add(dirs,dir.up,dir.right,dir.down,dir.left);
	ds_list_shuffle(dirs);
	
	// Check in each direction until we find a valid, visited cell, then 
	// remove the shared wall
	var i = 0;
	repeat(ds_list_size(dirs)) {
		var c_dir = dirs[|i];
		var temp =  get_adjacent_cell_coords(cur_cell,c_dir);
		if (is_valid_coord(temp)) {
			if (block_grid[# temp.x,temp.y].visited) {
				block_grid[# cur_cell.x,cur_cell.y].walls[c_dir] = false;
				block_grid[# temp.x,temp.y].walls[get_opposite_dir(c_dir)] = false;
				break;
			}
		}
		i++;
	}
	
	// free up memory
	ds_list_destroy(dirs);
	
	// adjust the frontier, removing the current cell and adding all unvisted 
	// adjacent cells that aren't already in the list
	adjust_frontier_list(cur_cell,index);
}
until (ds_list_size(frontier_list) <= 0);


// =========================
// UNECESSARY BUT HELPFUL
// =========================
// This just sets up the camera, don't worry about it
camera = new tso_camera();
camera.update_camera(BLOCKSIZE*block_grid_wid/2,BLOCKSIZE*block_grid_hig/2);
