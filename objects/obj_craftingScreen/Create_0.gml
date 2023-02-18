screen = new GuiScreen(
	RESOLUTION_W*0.05, RESOLUTION_H*0.05,
	RESOLUTION_W*0.95, RESOLUTION_H*0.95,
	[],
	[],
	spr_invPanel,
	0
);

var invInstance = instance_create_depth(
	RESOLUTION_W*0.05+20, RESOLUTION_H*0.05+20,
	depth-1,
	obj_craftingSlots,
	{
		rowLength : 3,
		invType : inventories.NONE,
		invArray : array_create(numOfSlots, -1),
	}
);

variable_struct_set(screen, "invInst", invInstance);