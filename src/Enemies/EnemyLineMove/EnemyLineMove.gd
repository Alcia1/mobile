extends "res://src/Enemies/EnemyBase/EnemyBase.gd"

func _process(delta):
	position.x += speed * delta
