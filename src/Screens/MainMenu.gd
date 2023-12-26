extends Node2D

@onready var EndlessMenu = get_child(0).find_child("EndlessMenu").get_child(0)
@onready var CampaignMenu = get_child(0).find_child("CampaignMenu").get_child(0).get_child(3).get_child(0)

var CampaignButton = preload("res://src/Screens/CampaignButton.tscn")

func _ready():
	SaveGame.loadFromFile()
	displayCampaignStats()
	displayEndlessStats()
	changeMusic()
	
	if SaveGame.saveDataSettings["sfx"] == 0:
		$Control/SettingsMenu/BGColor/sfx/Label.text = "unmute"
	else:
		$Control/SettingsMenu/BGColor/sfx/Label.text = "mute"

func displayEndlessStats():
	EndlessMenu.find_child("highScore").text = str(SaveGame.saveDataEndless["high_score"])
	EndlessMenu.find_child("distance").text = str(SaveGame.saveDataEndless["distance_traveled"]) + " m"
	EndlessMenu.find_child("enemies").text = str(SaveGame.saveDataEndless["enemies_defeated"])
	EndlessMenu.find_child("time").text = Time.get_time_string_from_unix_time(SaveGame.saveDataEndless["time_played"])

func displayCampaignStats():
	for i in CampaignMenu.get_children():
		CampaignMenu.remove_child(i)
	
	for i in SaveGame.saveDataCampaign.keys():
		var instance = CampaignButton.instantiate()
		
		instance.level = int(i)
		instance.get_child(0).text = "level " + i
		if SaveGame.saveDataCampaign[i]["high_score"] == SaveGame.saveDataCampaign[i]["max_score"]:
			instance.displayCompleted()
		if SaveGame.saveDataCampaign[i]["time"] != 0:
			instance.displayTime(Time.get_time_string_from_unix_time(SaveGame.saveDataCampaign[i]["time"]))
			
		CampaignMenu.add_child(instance)

func changeMusic():
	if SaveGame.saveDataSettings["music"] == 0:
		$Control/SettingsMenu/BGColor/music/Label.text = "unmute"
		$AudioStreamPlayer2D.stop()
	else:
		$Control/SettingsMenu/BGColor/music/Label.text = "mute"
		$AudioStreamPlayer2D.play()
