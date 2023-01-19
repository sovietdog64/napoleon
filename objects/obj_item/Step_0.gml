if(instance_exists(obj_game) && obj_game.gamePaused || obj_player.invOpen) return;
if(!isItem(item))
	return;
hsp *= 0.95;

//Set sprite to item sprite
sprite_index = item.itemSpr;

{//Collision
	{//Horizontal
		if(!place_free(x+hsp, y)) {
			while(place_free(x, y)) {
				x += sign(hsp);	
			}
			while(!place_free(x, y)) {
				x -= sign(hsp);
			}
			hsp = 0;
		}
		x += hsp;
	}
	
	{//Vertical
		if(!place_free(x, y+vsp)) {
			y = round(y)
			while(place_free(x, y)) {
				y += sign(vsp);
			}
			while(!place_free(x, y)) {
				y -= sign(vsp);
			}
			vsp = 0;
		}
		y += vsp;
	}
}

if(!canBePickedUp) pickUpCoolDown--;
if(pickUpCoolDown <= 0) {
	canBePickedUp = true;
	pickUpCoolDown = 0;
}

//Pick up item
if(canBePickedUp && !pickedUp && place_meeting(x, y, obj_player)) {
	pickedUp = true;
	var pickedUpItem = false;
	for(var i=0; i<array_length(global.hotbarItems); i++) {
		if(isItem(global.hotbarItems[i])) 
			continue;
		global.hotbarItems[i] = item;
		pickedUpItem = true;
		instance_destroy();
		return;
	}
	for(var i=0; i<array_length(global.invItems); i++) {
		if(isItem(global.invItems[i])) continue;
		global.invItems[i] = sprite_index;
		instance_destroy();
		break;
	}
}

if(y > room_height)
	instance_destroy();
