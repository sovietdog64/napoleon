/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event

if(!playerInRoom) {
	alarm_set(0, room_speed*0.1);
	return;
}

event_inherited();

