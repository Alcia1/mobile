#zająć się deltą w skryptach chodzenia
extends Area2D

var speed = 50

func _process(delta):
	position.x += speed * delta

func destroy():
	print("enemy dead")
	$Sprite2D.hide() #włącz animację
	$CollisionShape2D.disabled = true
	$GPUParticles2D.emitting = true
	
	await get_tree().create_timer(2).timeout #usuń
	queue_free()

func _input(event): #debug
	if event is InputEventKey and event.is_action_pressed("space"):
		destroy()

func _on_body_entered(body):
	if body.name == "player":
		if body.dashing == true:
			body.jump_count = 2
			body.dash_count = 1
			call_deferred("destroy")
		else:
			body.hit()
	else:
		speed = -speed
