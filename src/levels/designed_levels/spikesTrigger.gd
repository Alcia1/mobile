extends Area2D

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.disable_input = true
		body.velocity.x = 0
		await get_tree().create_timer(1.5).timeout
		if body.is_on_floor():
			body.find_child("AnimatedSprite2D").play("idle")
		get_parent().find_child("laser").activate()
		await get_tree().create_timer(0.3).timeout
		body.disable_input = false
		monitoring = false
