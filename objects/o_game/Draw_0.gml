for (var i = 0; i < block_grid_wid; i++) {
	for (var j = 0; j < block_grid_hig; j++) {
		var x1 = BLOCKSIZE*i;
		var y1 = BLOCKSIZE*j;
		var x2 = x1+BLOCKSIZE;
		var y2 = y1+BLOCKSIZE;
		var cur_block = block_grid[# i,j];
		
		if (cur_block.walls[0]) {
			draw_line(x1,y1,x2,y1);
		}
		if (cur_block.walls[1]) {
			draw_line(x2,y1,x2,y2);
		}
		if (cur_block.walls[2]) {
			draw_line(x1,y2,x2,y2);
		}
		if (cur_block.walls[3]) {
			draw_line(x1,y1,x1,y2);
		}
	}
}

if (keyboard_check_pressed(vk_space)) game_restart();