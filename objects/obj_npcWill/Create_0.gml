///@description This is an NPC template
talk = false;//bool stating of NPC can talk
//Example list of NPC dialogue lines include array if u want to show responses.
//The number before the semicolon shows which reaction the NPC will have. Actions are denoted in DialogueResponses script by number
npcName = "Will";
dialogueList = ["Man, those iron-armored animals don't stop!",
				"I ran out of ammunition because of them.",
				["Would you lend me some please? I really need it to get to where I need to be.",
					"5:Give 10x Musket ball?",
					"6:Don't give Musket ball."]];

layer = layer_get_id("Interactables");

NPCStepEventActions = function() {};

finishQuest = false;

saveNPC = true;

disappear = false;