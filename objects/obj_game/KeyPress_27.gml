if(!obj_player.invOpen){
	global.gamePaused = !global.gamePaused;
	drawPauseScreen = true;
} else obj_player.invOpen = false;