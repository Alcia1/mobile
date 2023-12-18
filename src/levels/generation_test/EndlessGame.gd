extends Node2D

var chunk1 = preload("res://src/levels/generation_test/chunks/test1.tscn")
var chunk2 = preload("res://src/levels/generation_test/chunks/test2.tscn")
var chunk3 = preload("res://src/levels/generation_test/chunks/test3.tscn")

var chunkData = [chunk1, chunk2, chunk3]

var nextChunkPosition = Vector2(0, -648)

@onready var player = get_child(0)

func _ready():
	loadNextChunk()

func loadNextChunk():
	var rng = RandomNumberGenerator.new()
	
	var instance = chunkData[rng.randi_range(0,2)].instantiate()
	instance.position = nextChunkPosition
	add_child(instance)
	
	nextChunkPosition.y -= 648

func _on_button_pressed():
	get_tree().reload_current_scene()
	
func save():
	var highScore = player.point_count
	var distance = player.distance_travelled
	var enemies = player.enemies_count
	SaveGame.saveEndless(highScore, distance, enemies)
	#var save = FileAccess.Open("user://save.txt", FileAccess.WRITE)
	#save.StoreLine(highScore.ToString())
	#save.Close()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/Screens/MainMenu.tscn")
