return;
if(!global.canLoadGame) {
	global.canLoadGame = true;
	return;
}
/// @description Load last state of room when room started
loadRoom2();
global.dead = false;