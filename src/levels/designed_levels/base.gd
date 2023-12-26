extends Node2D

@export var maxPoints = 1400
@export var levelNumber = 1

var time_start = 0
var time_end = 0

func _ready():
	if SaveGame.saveDataSettings["music"] == 0:
		$AudioStreamPlayer2D.stop()
	else:
		$AudioStreamPlayer2D.play()
	time_start = Time.get_unix_time_from_system()

func _on_end_trigger_body_entered(body):
	if body is CharacterBody2D:
		time_end = Time.get_unix_time_from_system()
		var time = time_end - time_start
		body.disable_input = true
		body.velocity.x = 0
		
		if body.point_count == maxPoints:
			find_child("debug").get_child(3).get_child(2).visible = true
		find_child("debug").get_child(3).animate(true)
		
		if body.point_count > SaveGame.saveDataCampaign[str(levelNumber)]["high_score"]:
			find_child("debug").get_child(3).get_child(1).text = "new record!"
			
		if SaveGame.saveDataCampaign[str(levelNumber)]["time"] == 0 or time < SaveGame.saveDataCampaign[str(levelNumber)]["time"]:
			print("level " + str(time))
			SaveGame.saveCampaign(levelNumber, body.point_count, time)
			$debug/bestTime/time.text = Time.get_time_string_from_unix_time(time)
			$debug/bestTime.animate(true)
		else:
			SaveGame.saveCampaign(levelNumber, body.point_count, SaveGame.saveDataCampaign[str(levelNumber)]["time"])

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/Screens/MainMenu.tscn")

func _on_button_pressed():
	get_tree().reload_current_scene()

func _on_pause_pressed():
	$player.process_mode = Node.PROCESS_MODE_DISABLED
	$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_DISABLED
	find_child("debug").get_child(5).animate(true)
	
func _on_resume_pressed():
	find_child("debug").get_child(5).animate(false)
	$player.process_mode = Node.PROCESS_MODE_INHERIT
	$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_INHERIT
