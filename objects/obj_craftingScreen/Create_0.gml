//Close all other screens when this one is being shown
for(var i=0; i<instance_number(obj_guiScreenPar); i++) {
	var inst = instance_find(obj_guiScreenPar, i);
	if(inst != id)
		instance_destroy(inst);
}

screen = new GuiScreen(
	RESOLUTION_W*0.05, RESOLUTION_H*0.05,
	RESOLUTION_W*0.95, RESOLUTION_H*0.95,
	[],
	[],
	spr_invPanel,
	0
);
#region inv GUI instance

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

#endregion inv GUI instance