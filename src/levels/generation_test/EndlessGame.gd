extends Node2D

var chunkData :Array

var nextChunkPosition = Vector2(0, -648)

@onready var player = get_child(0)

var time_start = 0
var time_end = 0

func _ready():
	if SaveGame.saveDataSettings["music"] == 0:
		$AudioStreamPlayer2D.stop()
	else:
		$AudioStreamPlayer2D.play()
	
	for i in 10:
		chunkData.append(load("res://src/levels/generation_test/chunks/"+str(i+1)+".tscn"))
	print(chunkData)
	
	loadNextChunk()
	time_start = Time.get_unix_time_from_system()

func loadNextChunk():
	var rng = RandomNumberGenerator.new()
	
	var instance = chunkData[rng.randi_range(0,9)].instantiate()
	instance.position = nextChunkPosition
	add_child(instance)
	
	nextChunkPosition.y -= 648

func _on_button_pressed():
	get_tree().reload_current_scene()
	
func save():
	time_end = Time.get_unix_time_from_system()
	var time = time_end - time_start
	
	var highScore = player.point_count
	var distance = player.distance_traveled
	var enemies = player.enemies_count
	SaveGame.saveEndless(highScore, distance, enemies, time)
	#var save = FileAccess.Open("user://save.txt", FileAccess.WRITE)
	#save.StoreLine(highScore.ToString())
	#save.Close()

func _on_back_button_pressed():
	#SceneManager.changeScene("res://src/Screens/MainMenu.tscn", "EndlessGame")
	get_tree().change_scene_to_file("res://src/Screens/MainMenu.tscn")

func _on_pause_pressed():
	get_child(0).process_mode = Node.PROCESS_MODE_DISABLED
	get_child(1).process_mode = Node.PROCESS_MODE_DISABLED
	find_child("debug").get_child(4).animate(true)
	#get_child(7).process_mode = Node.PROCESS_MODE_DISABLED

func _on_resume_pressed():
	find_child("debug").get_child(4).animate(false)
	get_child(0).process_mode = Node.PROCESS_MODE_INHERIT
	get_child(1).process_mode = Node.PROCESS_MODE_INHERIT
