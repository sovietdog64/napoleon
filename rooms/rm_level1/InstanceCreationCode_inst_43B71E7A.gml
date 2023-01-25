dialogueList = ["Will you assist me for a bit?", "Thank you so much!", 
				"So, there is a huge spider problem here.", 
				"The infestation started recently when some mysterious figures arrived", 
				["Can you please get rid of some spiders?",
					"4:Sure",
					"0:Sorry. I am a little busy right now."]
			   ];
npcName = "Liam";



NPCStepEventActions = function() {
	if(finishQuest) {
		finishQuest = false;
		newTextBox("Thank you so much for the help!");
	}
}	