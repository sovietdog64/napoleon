persistent = true;
if(instance_exists(obj_player)) {
	targX = obj_player.x;
	targY = obj_player.y;
}
else {
	targX = 0;
	targY = 0;
}
screenShakeDuration = 0;
screenShakeLvl = 0;
function screenShake(duration, screenShakeLevel) {
	screenShakeDuration = duration;
	screenShakeLvl = screenShakeLevel;
	alarm_set(0, 1);
}