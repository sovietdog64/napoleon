gamePaused = false;
persistent = true;


drawPauseScreen = false;

global.invItems = array_create(8, -1);
global.hotbarItems = array_create(3, -1);
global.equippedItem = 0;

global.spawnX = 0;
global.spawnY = 0;
global.spawnRoom = rm_entrance;
global.setPosToSpawnPos = false;

//Array containing quest structs.
global.activeQuests = array_create(0);
//Array containing all completed quest names
global.completedQuests = array_create(0);

global.npcActions = 
{
	options : {
		gunsmith : function (npcInst) {
						//Musket purchase
						if(npcInst.optionClicked == 0) {
							var result = drawPopup(camWidth()/2, camHeight()/2, "Purchase", spr_musket, "Musket for 100 gold?", "yes/no");
							if(result != undefined) {
								//If "yes" was clicked
								if(result) {
									//TODO: Check if enough gold and complete transaction
									if(global.level >= 5) {
										var newMusket = new Firearm(spr_musket, spr_musketBall, spr_musketBallProj, "Musket Ball", 10, 80, musketReload, 0, 1, 150);
										var gaveItem = giveItemToPlayer(newMusket);
										if(!gaveItem) {
											drawNotification(obj_player.x, obj_player.y-100, "Inventory too full!", c_red, room_speed*3, 1, fa_center, 0);
											npcInst.resetNPC();
										}
										else {
											//TODO: Charge money
											npcInst.resetNPC();
										}
									}
									else
										drawNotification(obj_player.x, obj_player.y-100, "Not enough levels! (Lvl 5 required)", c_red, room_speed*3, 2, fa_center, 0);
									npcInst.resetNPC();
								}
								//If "no" was clicked
								else if(!result) {
									//Exit from menu
									npcInst.resetNPC();
								}
							}
						}
						//Musket ball purchase
						if(npcInst.optionClicked == 1) {
							var result = drawPopup(camWidth()/2, camHeight()/2, "Purchase", spr_musketBall, "Musket Ball 10x for 100 gold?", "yes/no");
							if(result != undefined) {
								if(result) {
									//TODO: Check if enough gold and complete transaction
									if(global.level >= 5) {
										var newMusketBall = new Item(spr_musketBall, 10, 0);
										var gaveItem = giveItemToPlayer(newMusketBall);
										if(!gaveItem) {
											drawNotification(obj_player.x, obj_player.y-100, "Inventory too full!", c_red, room_speed*3, 1, fa_center, 0);
											npcInst.resetNPC();
										}
										else {
											//TODO: Charge money
											npcInst.resetNPC();
										}
									}
									npcInst.resetNPC();
								}
								else if(!result) {
									//Exit from menu
									npcInst.resetNPC();
								}
							}
						}
					},
		
	},
	drawGUI : {
		liam : function(npcInst) {
					for(var i=0; i<array_length(global.activeQuests); i++) {
						var quest = global.activeQuests[i];
						if(quest.questName != "Spider Slayer") 
							return;
						if(quest.progress >= 1 && distanceBetweenPoints(npcInst.x, npcInst.y, obj_player.x, obj_player.y) <= 100) {
							npcInst.skipDefaultActions = true;
							draw_set_color(c_green)
							draw_text_transformed(npcInst.x-camX(), npcInst.y+50-camY(), "Left click to finish Spider Slayer quest", 2, 2, 0);
							if(mouse_check_button_pressed(mb_left)) {
								//Balance xp gain base off of level
								if(global.level >= 5)
									global.xp += 10;
								else
									global.xp += 30;
								array_delete(global.activeQuests, i, 1);
								npcInst.resetNPC();
							}
						}
					}
					if(npcInst.skipDefaultActions)
						return;
					if(npcInst.doneTalking) {
						obj_player.inDialogue = true;
						var result = drawPopup(camWidth()/2, camHeight()/2, "Quest", spr_spiderQ, "Kill 10 spiders?", "yes/no");
						show_debug_message(result)
						if(result) {
							obj_player.inDialogue = false;
							//Check if player has quest active/is already done with quest
							for(var i=0; i<array_length(global.activeQuests); i++) {
								if(global.activeQuests[i].questName == "Spider Slayer") {
									drawNotification(obj_player.x, obj_player.y-40, "That quest is already active!", c_red, room_speed*5, 4, fa_center, 0);
									npcInst.resetNPC();
									return;
								}
							}
			
							for(var i=0; i<array_length(global.completedQuests); i++) {
								if(global.completedQuests[i] == "Spider Slayer") {
									drawNotification(obj_player.x, obj_player.y-40, "That one-time quest is already completed!", c_red, room_speed*5, 4, fa_center, 0);
									npcInst.resetNPC();
									return;
								}
							}
							//If quest is not done already / is not active, assign quest
							var questStruct =
							{
								questName : "Spider Slayer",
								questDesc : "Kill 10 spiders",
								kills : 0,
								maxKills : 10,
								progress : 0,
							}
							array_push(global.activeQuests, questStruct);
							npcInst.resetNPC();
						}
						else if(result == 0) {
							npcInst.resetNPC();
						}
					}
				},
		
	}
}