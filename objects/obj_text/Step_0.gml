lerpProgress += (1 - lerpProgress) / 60;
textProgress += global.textSpeed;

x1 = lerp(x1, x1Target, lerpProgress);
x2 = lerp(x2, x2Target, lerpProgress);

//Cycle through responses
var up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
responseSelected  += (down - up);
var maxVal = array_length(responses)-1;
var minVal = 0;
if(responseSelected > maxVal) 
	responseSelected = minVal;
if(responseSelected < minVal)
	responseSelected = maxVal;

//Delete textbox and if another textbox is in queue, it will be displayed
if(keyboard_check_pressed(vk_space)) {
	var textMsgLen = string_length(textMsg);
	if(textProgress >= textMsgLen) {
		if(responses[0] != -1) {
			with(originInstance)
				DialogueResponses(other.responseScripts[other.responseSelected]);
		}
		instance_destroy();
		if(instance_exists(obj_textQueued)) {
			with(obj_textQueued)
				ticket--;
		}
	}
	else if(textProgress > 2) {
		textProgress = textMsgLen;
	}
}