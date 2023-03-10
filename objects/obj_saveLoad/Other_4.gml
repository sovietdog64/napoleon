/// @description Load last state of room when room started
if(skipRoomLoad) {
	skipRoomLoad = false;
	return;
}
	
if(room == rm_init || room == rm_mainMenu)
	return;

loadRoom();
global.dead = false;