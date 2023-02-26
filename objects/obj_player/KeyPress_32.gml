if(instance_exists(obj_craftingScreen)) {
	var itemsNeeded = [new Wood(4)];
	show_debug_message(InvSearchContainsOnly(obj_craftingScreen.craftingSlots, itemsNeeded))
}