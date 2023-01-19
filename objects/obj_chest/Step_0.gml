if(instance_exists(obj_game) && obj_game.gamePaused) return;
if(!opened) sprite_index = spr_chest; else sprite_index = spr_chestOpen;
if(place_meeting(x, y, obj_player) && !opened) {
	for(var i=0; i<array_length(items); i++) {
		if(items[i] == -1) 
			continue;
		var temp = copyStruct(items[i]);
		var inst = instance_create_layer(x, y-100, "Instances", obj_item);
		inst.item = temp;
		items[i] = -1;
	}
	opened = true;
}