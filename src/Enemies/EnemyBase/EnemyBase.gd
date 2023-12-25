#zająć się deltą w skryptach chodzenia
extends Area2D

var speed = 50

@export var points = 100
#func _process(delta):
#	position.x += speed * delta

func destroy():
	print("enemy dead")
	#$sfxHit.play()
	$Sprite2D.hide() #włącz animację
	$CollisionShape2D.disabled = true
	$GPUParticles2D.emitting = true
	$Label.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(get_child(2), "position:y", -10, 0.5)
	await tween.finished
	tween.kill()
	$Label.visible = false
	
	await get_tree().create_timer(2).timeout #usuń
	if get_parent().name == "EnemyBoundary":
		get_parent().queue_free()
	else:
		queue_free()

func _input(event): #debug
	if event is InputEventKey and event.is_action_pressed("space"):
		destroy()

func _on_body_entered(body):
	if body.name == "player":
		if body.dashing == true:
			body.jump_count = 2
			body.dash_count = 1
			body.enemies_count += 1
			body.point_count += points
			if points != 0:
				$Label.text = str(points)
			else:
				$Label.text = ""
			call_deferred("destroy")
		else:
			body.call_deferred("hit")
	else:
		speed = -speed
