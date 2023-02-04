 spd = 20;
spd *= 3;
motion_set(direction, spd);
pierce = 0; //Amount of enemies can pierce
damage = 1;
enemyDamage = false;
damageSourceInst = obj_player;
knockBack = 10;

enemiesCollided = array_create(0);