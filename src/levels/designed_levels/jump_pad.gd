extends Node2D

var sfx_disabled = false

func _ready():
	if SaveGame.saveDataSettings["sfx"] == 0:
		sfx_disabled = true

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.call_deferred("jumpPad")
		if !sfx_disabled:
			$sfx.play()
