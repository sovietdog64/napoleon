///@description Pause screen

//If not paused & screens are open when esc is pressed, exit those screens.
if((instance_exists(obj_inventory) || instance_exists(obj_guiScreenPar)) && !instance_exists(obj_pauseScreen)) {
	closeAllScreens();
	return;
}

//If is paused, then toggle pause screen
global.gamePaused = !global.gamePaused;
if(global.gamePaused)
	instance_create_depth(0,0,0,obj_pauseScreen)
else
	instance_destroy(obj_pauseScreen)