//var grid = ds_grid_create(20,20);

//for(var r=0; r<20; r++)
//	for(var c=0; c<20; c++)
//		grid[# c, r] = irandom(9)

//var inst = instance_create_depth(x,y,depth,obj_tree);
//inst.testGrid = grid;
//inst.testArr = ["aeeea", "idk"];

//var inst2 = instance_create_depth(x,y,depth,obj_tree);
//inst2.testArr2 = [inst.testArr];


return;

var str = "";
str += printGrid(grid)

show_debug_message("-------------------------------")
str += "\n-------------------------------\n";

str += print2DArray(dsGridToArr(grid));

clipboard_set_text(str)