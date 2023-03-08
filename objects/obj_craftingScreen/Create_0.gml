//Close all other screens when this one is being shown
for(var i=0; i<instance_number(obj_guiScreenPar); i++) {
	var inst = instance_find(obj_guiScreenPar, i);
	if(inst != id)
		instance_destroy(inst);
}

craftRecipie = 0;

craftingSlots = array_create(numOfSlots, -1);

resultInv = 0;
itemResultSlot = array_create(1, -1);

btnList = [];
craftingRecipieBook = [];//Contains all craftable sprites

screen = new GuiScreen(
	RESOLUTION_W*0.05, RESOLUTION_H*0.05,
	RESOLUTION_W*0.95, RESOLUTION_H*0.95,
	btnList,
	[],
	spr_invPanel,
	0
);
#region inv GUI instances

variable_struct_set(screen, "invs", array_create(0));

var invInstance = instance_create_depth(
	screen.x1+20, screen.y1+20,
	depth-1,
	obj_inventory,
	{
		rowLength : 4,
		invType : inventories.NONE,
		invArray : craftingSlots,
		slotSize : 32,
		itemSize : 32,
		throwOutItems : true,
	}
);
array_push(screen.invs, invInstance);

var playerInv = instance_create_depth(
	screen.x1+20, screen.y2-150,
	depth-1,
	obj_inventory,
	{
		rowLength : 8,
		invType : inventories.PLAYER_INV,
		invArray : global.invItems,
		slotSize : 32,
		itemSize : 32,
	}
);
array_push(screen.invs, playerInv);

var playerInv = instance_create_depth(
	screen.x1+8*45-10, screen.y2-150,
	depth-1,
	obj_inventory,
	{
		rowLength : 3,
		invType : inventories.PLAYER_INV,
		invArray : global.hotbarItems,
		slotSize : 32,
		itemSize : 32,
	}
);
array_push(screen.invs, playerInv);

resultInv = instance_create_depth(
	screen.x1+20+4*50, screen.y1+20,
	depth-1,
	obj_inventory,
	{
		rowLength : 1,
		invArray : itemResultSlot,
		slotSize : 32,
		itemSize : 32,
		throwOutItems : false,
		cannotPlaceItem : true,
	}
);
array_push(screen.invs, resultInv)


#endregion inv GUI instances

global.screenOpen = true;

alarm_set(0, 1);