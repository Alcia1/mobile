extends Area2D

func destroy():
	print("enemy dead")
	$Sprite2D.hide() #włącz animację
	$CollisionShape2D.disabled = true
	$GPUParticles2D.emitting = true
	
	await get_tree().create_timer(2).timeout #usuń
	queue_free()

func _input(event):
	if event is InputEventKey and event.is_action_pressed("space"):
		destroy()

func _on_enemy_body_entered(body):
	print(body.dashing)
	if body.dashing == true:
		body.jump_count = 2
		body.dash_count = 1
		call_deferred("destroy")
	else:
		body.hit()
