/// @description Load last state of room when room started
if(room == rm_init || room == rm_mainMenu)
	return;

loadRoom2();
global.dead = false;