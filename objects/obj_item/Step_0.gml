solid = false;
if(global.invOpen) return;
if(!isItem(item)) {
	instance_destroy();
	return;
}

hsp *= 0.95;
vsp *= 0.95;

//Set sprite to item sprite
sprite_index = item.itemSpr;

//Collision
{
	{//Horizontal
		if(!place_free(x+hsp, y) && hsp != 0) {
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
		if(!place_free(x, y+vsp) && vsp != 0) {
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
	
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

lifeSpan--;
if(lifeSpan <= 0) {
	instance_destroy();
}

//Pick up item
if(pickUpCoolDown > 0) 
	pickUpCoolDown--;
else if(place_meeting(x, y, obj_player)) {
	if(giveItemToPlayer(item))
		instance_destroy();
}
