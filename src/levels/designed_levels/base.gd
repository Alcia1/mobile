extends Node2D

@export var maxPoints = 1400
@export var levelNumber = 1

func _ready():
	if SaveGame.saveDataSettings["music"] == 0:
		$AudioStreamPlayer2D.stop()
	else:
		$AudioStreamPlayer2D.play()

func _on_end_trigger_body_entered(body):
	if body is CharacterBody2D:
		body.disable_input = true
		body.velocity.x = 0
		
		if body.point_count == maxPoints:
			find_child("debug").get_child(3).get_child(2).visible = true
		find_child("debug").get_child(3).animate(true)
		
		if body.point_count > SaveGame.saveDataCampaign[str(levelNumber)]["high_score"]:
			find_child("debug").get_child(3).get_child(1).text = "new record!"
		SaveGame.saveCampaign(levelNumber, body.point_count)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/Screens/MainMenu.tscn")

func _on_button_pressed():
	get_tree().reload_current_scene()

func _on_pause_pressed():
	get_child(0).process_mode = Node.PROCESS_MODE_DISABLED
	get_child(7).process_mode = Node.PROCESS_MODE_DISABLED
	find_child("debug").get_child(5).animate(true)
	
func _on_resume_pressed():
	find_child("debug").get_child(5).animate(false)
	get_child(0).process_mode = Node.PROCESS_MODE_INHERIT
	get_child(7).process_mode = Node.PROCESS_MODE_INHERIT
