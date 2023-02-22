depth = layer_get_depth(layer_get_id("Instances"))+1;
var maxHouses = ceil(sprite_width/250);
var leftCount = irandom_range(1, maxHouses);
var rightCount = irandom_range(1, maxHouses);
leftHouses = [];
rightHouses = [];

//Adding houses
for(var i=0; i<leftCount; i++) {
	//40% chance of house spawning
	if(random(1) < 0.4) {
		var spr = spr_house;
		if(image_angle == 0)
			spr = choose(spr_house4);
		if(image_angle == 90)
			spr = choose(spr_house);
		if(image_angle == 180)
			spr = choose(spr_house2);
		if(image_angle == 270)
			spr = choose(spr_house3);
		var w = sprite_get_width(spr)+30;
		//Spawning house with its edge tangent to the path edge
		//This thing basically takes a point on the path, and spawns a house next to it.
		var xx = x+lengthdir_x(sprite_height/2, image_angle+90);//+90 degrees to spawn on left
		var yy = y+lengthdir_y(sprite_height/2, image_angle+90);
		xx += lengthdir_x(i*w+HIGHEST_HOUSE_H, image_angle);//The point depends on which house it is spawning as indicated by the i*w
		yy += lengthdir_y(i*w+HIGHEST_HOUSE_H, image_angle);
		var inst = instance_create_layer(xx,
										yy,
										"Structures",
										obj_house, {creatorId : id});
		inst.sprite_index = spr;
		array_push(leftHouses, inst);
	}
}

for(var i=0; i<rightCount; i++) {
	if(random(1) < 0.4) {
		var spr = spr_house;
		if(image_angle == 0)
			spr = choose(spr_house2);
		if(image_angle == 90)
			spr = choose(spr_house3);
		if(image_angle == 180)
			spr = choose(spr_house4);
		if(image_angle == 270)
			spr = choose(spr_house);
		var w = sprite_get_width(spr)+30;
		var xx = x+lengthdir_x(sprite_height/2, image_angle-90);//-90 degrees to spawn on the right of the path.
		var yy = y+lengthdir_y(sprite_height/2, image_angle-90);
		xx += lengthdir_x(i*w+HIGHEST_HOUSE_H, image_angle);
		yy += lengthdir_y(i*w+HIGHEST_HOUSE_H, image_angle);
		var inst = instance_create_layer(xx,
										yy,
										"Structures",
										obj_house, {creatorId : id});
		inst.sprite_index = spr;
		array_push(rightHouses, inst);
	}
}
	
event_inherited()