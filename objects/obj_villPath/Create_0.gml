var maxHouses = ceil(sprite_width/250);
var leftCount = irandom_range(1, maxHouses);
var rightCount = irandom_range(1, maxHouses);
leftHouses = [];
rightHouses = [];
for(var i=0; i<leftCount; i++) {
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
		var xx = x+lengthdir_x(sprite_height/2, image_angle+90);
		var yy = y+lengthdir_y(sprite_height/2, image_angle+90);
		xx += lengthdir_x(i*w+100, image_angle);
		yy += lengthdir_y(i*w+100, image_angle);
		var inst = instance_create_layer(xx,
										yy,
										"Structures",
										obj_house);
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
		var xx = x+lengthdir_x(sprite_height/2, image_angle-90);
		var yy = y+lengthdir_y(sprite_height/2, image_angle-90);
		xx += lengthdir_x(i*w+100, image_angle);
		yy += lengthdir_y(i*w+100, image_angle);
		var inst = instance_create_layer(xx,
										yy,
										"Structures",
										obj_house);
		inst.sprite_index = spr;
		array_push(rightHouses, inst);
	}
}