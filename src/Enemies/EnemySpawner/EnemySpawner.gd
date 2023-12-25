extends Node2D

var packedEnemy = preload("res://src/Enemies/EnemyLineMove/EnemyBoundary.tscn")

@export var leftWallCords = Vector2(-51,0)
@export var rightWallCords = Vector2(57,0)

@export var moving = true

func _process(_delta):
	if get_child_count() == 0:
		var instance = packedEnemy.instantiate()
		instance.get_child(1).get_child(0).position = leftWallCords
		instance.get_child(1).get_child(1).position = rightWallCords
		
		if moving == false:
			instance.get_child(0).exportedMove = false
		
		instance.get_child(0).points = 0
		
		add_child(instance)
