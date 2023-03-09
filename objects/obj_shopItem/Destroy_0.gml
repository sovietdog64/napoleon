var inst = instance_nearest(x,y, obj_merchant);
if(inst != noone)
	with(inst) {
		alarm_set(0, room_speed*2);
		sprite_index = spr_merchantHappy;
	}