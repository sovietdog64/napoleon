//Close all other screens when this one is being shown
for(var i=0; i<instance_number(obj_guiScreenPar); i++) {
	var inst = instance_find(obj_guiScreenPar, i);
	if(inst != id)
		instance_destroy(inst);
}

#region buttons

var w = sprite_get_width(spr_btnCrafting);
var xx = RESOLUTION_W-w*1.5;
var yy = RESOLUTION_H*0.75;
var btnAction = function() {
	closeAllInvs();
	instance_create_depth(0, 0, 0, obj_craftingScreen);
}

var btnArray = [new GuiButton(spr_btnCrafting, 0, xx, yy, btnAction)]

#endregion buttons

//Create object that has all the screen's data
screen = new GuiScreen(
	RESOLUTION_W*0.05, RESOLUTION_H*0.05,
	RESOLUTION_W*0.95, RESOLUTION_H*0.95,
	btnArray,
	[],
	spr_invPanel,
	0
)

#region inv GUI instances

var invGui = instance_create_depth(RESOLUTION_W*0.1,RESOLUTION_H*0.1,
						depth-1,
						obj_inventory,
						{
							invArray : global.invItems,
							invType : inventories.PLAYER_INV,
						});
						
var hotbarInvGui = instance_create_depth(RESOLUTION_W*0.1,RESOLUTION_H*0.75,
						depth-1,
						obj_inventory,
						{
							invArray : global.hotbarItems,
							invType : inventories.PLAYER_INV,
							rowLength : array_length(global.hotbarItems),
						});
variable_struct_set(screen, "invs", []);
array_push(screen.invs, invGui);
array_push(screen.invs, hotbarInvGui);

#endregion inv GUI instances

global.screenOpen = true;