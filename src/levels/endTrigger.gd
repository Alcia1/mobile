extends Area2D

var passed = false
var player_positionY = 0

func _on_body_entered(body):
	if body.name == "player":
		player_positionY = body.position.y

func _on_body_exited(body):
	if body.name == "player":
		if body.position.y < player_positionY:
			passed = true
			get_parent().find_child("debug").get_child(1).visible = true
			body.disable_input = true###TEST DISABLE INPUT
		else:
			passed = false
#zmienić disable input
