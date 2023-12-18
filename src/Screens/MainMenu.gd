extends Node2D

func _ready():
	get_child(0).find_child("EndlessMenu").get_child(0).find_child("highScore").text = str(SaveGame.saveDataEndless["high_score"])
	get_child(0).find_child("EndlessMenu").get_child(0).find_child("distance").text = str(SaveGame.saveDataEndless["distance_travelled"]) + " m"
