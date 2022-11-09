extends Area2D

func _on_enemy_body_entered(body):
	if body.dashing != "":
		print("enemy dead")
		body.jump_count = 2
		body.dash_count = 1
		hide()
		queue_free()
	else:
		body.hit()
