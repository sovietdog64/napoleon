///@description This is an NPC template
talk = false;//bool stating of NPC can talk
//Example list of NPC dialogue lines include %opptions% to show options instead of dialogue. optionList must not be empty!
dialogueList = ["aeugh", "test", "message."];
dialogueIndex = 0;//Index of which line of dialogue is currently being said.
npcName = "Bob";
optionList = ["example", "example2"];
optionReactionList = ["test1%%test1.1%%test1.2", "test2%%"];

canShowOptions = true;
optionReactionIndex = -1;
currentReactionMessages = undefined;
reactionIndex = 0;

optionActions = 0;
//These functions must be fully declared in instance creation code
doNPCActions = function(npcInst) {};
doNPCDrawGUIActions = function(npcInst) {};

shouldReact = false;

doneTalking = false;

optionClicked = undefined;

skipDefaultActions = false;

resetNPC = function() {
	doneTalking = false;
	skipDefaultActions = false;
	talk = false;
	dialogueIndex = 0;
	canShowOptions = true;
	optionReactionIndex = -1;
	currentReactionMessages = undefined;
	reactionIndex = 0;
	if(instance_exists(obj_player)) obj_player.inDialogue = false;
	optionClicked = undefined;
}

layer = layer_get_id("Interactables");