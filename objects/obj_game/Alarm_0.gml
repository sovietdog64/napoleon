/// @description updating if game paused or not
global.gamePaused = instance_exists(obj_pauseScreen);
global.screenOpen = instance_exists(obj_guiScreenPar);

alarm_set(0, room_speed);