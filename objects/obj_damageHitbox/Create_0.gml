enemyHit = false;
damage = 1;
lifeSpan = room_speed * 0.5;
instToFollow = noone;
followOffsetX = 0;
followOffsetY = 0;
lifeSpanSameAsInst = 0; //If the hitbox must last the same duration as the instance to follow
knockbackSpeed = 20; //Speed of knockback
enemiesHit = array_create(0)//List of enemies that were hit (used to prevent double-hitting, and to hit enemies that walk into the hitbox)