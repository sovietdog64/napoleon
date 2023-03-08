var collided = instance_place(x, y, obj_player);
if(collided && !prevPlayerEntered) {
	prevPlayerEntered = true;
	room_goto(terrainGenTest);
}
else if(!collided && prevPlayerEntered)
	prevPlayerEntered = false;