alarm_set(1, irandom_range(room_speed, room_speed*5))

var snd = choose(idle1Gobl, idle2Gobl);

if(state == states.MOVE || state == states.ATTACKED)
	snd = choose(goblAngry, goblAngry2);

audio_play_sound(snd,0,0);