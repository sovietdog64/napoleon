///@description This is an NPC template
talk = false;//bool stating of NPC can talk
//Example list of NPC dialogue lines include array if u want to show responses.
//The number before the semicolon shows which reaction the NPC will have. Actions are denoted in DialogueResponses script by number
dialogueList = ["aeugh", ["test question title?","1:test1", "2:test2"]];
npcName = "Bob";

layer = layer_get_id("Interactables");