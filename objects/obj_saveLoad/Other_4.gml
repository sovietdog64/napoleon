/// @description Load last state of room when room started
if(skipRoomLoad) {
	skipRoomLoad = false;
	return;
}
	
if(room == rm_init || room == rm_mainMenu || room == rm_cutscene)
	return;

loadRoom();
global.dead = false;