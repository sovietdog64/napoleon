enemyHit = false;
damage = 1;
lifeSpan = room_speed * 0.5;
instToFollow = noone;
dmgSourceInst = obj_player;
followOffsetX = 0;
followOffsetY = 0;
lifeSpanSameAsInst = false; //If the hitbox must last the same duration as the instance to follow
knockbackDur = 20; //duration of knockback
enemiesHit = array_create(0)//List of enemies that were hit (used to prevent double-hitting, and to hit enemies that walk into the hitbox)
scrnShakeLevel = 5;
scrnShakeDur = room_speed*0.1;
dontHit = false;

playSwoop = true;