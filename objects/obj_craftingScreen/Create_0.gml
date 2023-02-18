screen = new GuiScreen(
	RESOLUTION_W*0.1, RESOLUTION_H*0.1,
	RESOLUTION_W*0.9, RESOLUTION_H*0.9,
	[],
	[],
	spr_invPanel,
	0
);

var invInstance = instance_create_depth(
	RESOLUTION_W*0.1+20, RESOLUTION_H*0.1+20,
	depth-1,
	obj_inventory,
	{
		rowLength : 3,
		invType : inventories.NONE,
		invArray : array_create(numOfSlots, -1),
	}
);

variable_struct_set(screen, "invInst", invInstance);