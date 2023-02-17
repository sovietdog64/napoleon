global.noHud = !global.noHud;
if(global.noHud) {
	instance_create_layer(RESOLUTION_W*0.1,RESOLUTION_H*0.1,
							layer,
							obj_inventory,
							{
								invArray : global.invItems,
								invType : inventories.PLAYER_INV,
							});
						
	instance_create_layer(RESOLUTION_W*0.1,RESOLUTION_H*0.8,
							layer,
							obj_inventory,
							{
								invArray : global.hotbarItems,
								invType : inventories.PLAYER_INV,
								rowLength : array_length(global.hotbarItems),
							});
}
else {
	instance_destroy(obj_inventory)
}