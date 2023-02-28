if(array_length(bridgedTo) <= 0 && !dontExtend) {
	var targRoomDirection = choose("left", "right", "up", "down");
	var xx = mapX;
	var yy = mapY;
	
	while(!withinBoundsGrid(creatorID.dungeonMap, xx, yy)) {
		xx = mapX;
		yy = mapY;
		targRoomDirection = choose("left", "right", "up", "down");
		
		switch(targRoomDirection) {
	
			case "left":
				xx--;
			break;
	
			case "right":
				xx++;
			break;
		
			case "up":
				yy--;
			break;
	
			case "down":
				yy++;
			break;
	
		}
		
		
	}
	
	var bridgedToRoom = creatorID.dungeonMap[# xx, yy];
	array_push(bridgedTo, bridgedToRoom);
	array_push(bridgedToRoom.bridgedTo, id);
}