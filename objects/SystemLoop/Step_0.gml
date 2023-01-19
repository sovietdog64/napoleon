// Player's level when XP meets the level up threshold
if (global.xp >= global.levelUpThreshold) {
	global.level++;
	global.xp = 0;
	global.levelUpThreshold *= 2;
}