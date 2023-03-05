var grid = ds_grid_create(20,20);

for(var r=0; r<20; r++)
	for(var c=0; c<20; c++)
		grid[# c, r] = irandom(9)

var roomStruct = {
	instances : [],
	deactivatedInstances : [],
	instMem : {}, //This is the struct containing all inst structs. The other two arrays will reference these structs.
	memory : {
		arrays : {},
		dsGrids : {},
		dsLists : {},
		structs : {},
	},
	savedMemory : {//This struct contains all structs saved and their reference in the save file.
		savedArrays : {},
		savedDsGrids : {},
		savedDsLists : {},
		savedStructs : {},
	}
};
var inst = instance_create_depth(x,y,depth,obj_tree);
inst.testGrid = grid;

saveRoom2();

clipboard_set_text(json_stringify(global.levelData))

return;

var str = "";
str += printGrid(grid)

show_debug_message("-------------------------------")
str += "\n-------------------------------\n";

str += print2DArray(dsGridToArr(grid));

clipboard_set_text(str)