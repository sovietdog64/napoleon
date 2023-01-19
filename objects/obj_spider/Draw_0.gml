//Right 4 legs
for(var i = 0; i < 4; i++) {
	
	for(var j=0; j<150; j += 9) {
		var dir = point_direction(x, y, rTargX[i], rTargY[i]);
		var dist = distance_to_point(rTargX[i], rTargY[i]);
		if(!wallCrawling)
			if(!(dir < 300 || dir > 350 || dist > 85))
				break;
		var skipDegree = false;
		for(var l=0; l<4; l++) {
			if(l == i) 
				continue;
			if(j == rDegrees[l]) 
				skipDegree = true;
		}
		if(skipDegree) 
			continue;
		var temp = 0;
		var foundPos = false;
		if(dist > 85) {
			while(temp < 80) {
				var xx = x+(temp * dsin(120));
				var yy = y+(-temp * dcos(120));
				if(collision_point(xx, yy, obj_solid, 0, 1)) {
					rDegrees[i] = j;
					rTargX[i] = xx;
					rTargY[i] = yy;
					foundPos = true;
					break;
				}
				temp += 5;
			}
			break;
		}
		while(temp < 90) {
			var xx = x+(temp * dsin(j));
			var yy = y+(-temp * dcos(j));
			draw_set_color(c_white);
			if(collision_point(xx, yy, obj_solid, 0, 1)) {
				rDegrees[i] = j;
				rTargX[i] = xx;
				rTargY[i] = yy;
				foundPos = true;
				break;
			}
			temp += 5;
		}
		if (foundPos)
			break;
	}
	draw_set_color(c_lime);
	drawLimbRight(x, y, rTargX[i], rTargY[i], 50, 60, c_lime,c_lime,3,2);
}

//Left 4 legs
for(var i=0; i<4; i++) {
	for(var j=240; j<350; j += 9) {
		var dir = point_direction(x, y, lTargX[i], lTargY[i]);
		var dist = distance_to_point(lTargX[i], lTargY[i]);
		if(!(dir < 190 || dir > 240 || dist > 85))
			break;
		var skipDegree = false;
		for(var l=0; l<4; l++) {
			if(l == i) continue;
			if(j == lDegrees[l]) 
			skipDegree = true;
		}
		if(skipDegree) 
			continue;
		var temp = 0;
		var foundPos = false;
		if(dist > 85) {
			while(temp < 80) {
				var xx = x+(temp * dsin(150));
				var yy = y+(-temp * dcos(150));
				if(collision_point(xx, yy, obj_solid, 0, 1)) {
					lDegrees[i] = j;
					lTargX[i] = xx;
					lTargY[i] = yy;
					foundPos = true;
					break;
				}
				temp += 5;
			}
			break;
		}
		while(temp < 90) {
			var xx = x+(temp * dsin(j));
			var yy = y+(-temp * dcos(j));
			draw_set_color(c_white);
			if(collision_point(xx, yy, obj_solid, 0, 1)) {
				lDegrees[i] = j;
				lTargX[i] = xx;
				lTargY[i] = yy;
				foundPos = true;
				break;
			}
			temp += 5;
		}
		if (foundPos)
			break;
	}
	draw_set_color(c_blue);
	drawSpiderLimbLeft(x, y, lTargX[i], lTargY[i], 50, 60, c_white,c_white,3,2);
}

draw_self();

{//Drawing health bar
	draw_set_color(c_black);
	draw_rectangle(x - 22, y - 32, x + 22, y - 18, 0);
	draw_set_color(c_green);
	draw_rectangle(x - 20, y - 30, (x - 20) + 40 * (hp/maxHp), y - 20, 0);
}
