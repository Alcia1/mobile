extends "res://src/Enemies/EnemyBase/EnemyBase.gd"

@export var delay = 0
@export var exportedMove = true

var moving = false

func _ready():
	await get_tree().create_timer(delay).timeout
	moving = true
	if exportedMove == false:
		moving = false

func _process(delta):
	if $Sprite2D.visible and moving:
		position.x += speed * delta
	
	if speed > 0:
		$Sprite2D.flip_h = false
	elif speed < 0:
		$Sprite2D.flip_h = true
