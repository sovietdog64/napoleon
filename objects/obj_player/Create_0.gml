hsp = 0;//horizontal speed
vsp = 0;//vertical speed
hspWalk = 8;//horizontal speed when walking
vspJump = -16;//vertical speed when jumping
canJump = false;//bool for whether player can jump.
inDialogue = false;//bool stating whether the player is talking with an NPC.
invOpen = false;
clickedItem = -1;

hurtCooldown = 0;

followingSequences = array_create(0); //List of animations that follow the player.

lungeForward = false;

isHurt = false;

if(!variable_global_exists("hp"))global.hp = 5;//health
if(!variable_global_exists("dead"))global.dead = false;
sprite_index = spr_player;
leftAttackCooldown = 0;

safeX = x;
safeY = y;

enteredX = x;
enteredY = y;

state = PlayerStateFree;
lastState = state;