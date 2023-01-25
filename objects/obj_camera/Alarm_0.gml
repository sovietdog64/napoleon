/// @description Screen Shake
if(screenShakeDuration <= 0)
	return;
x += random_range(-screenShakeLvl, screenShakeLvl);
y += random_range(-screenShakeLvl, screenShakeLvl);

alarm_set(0, 5);