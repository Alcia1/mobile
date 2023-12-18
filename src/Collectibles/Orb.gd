extends Area2D

func destroy():
	print("orb collected")
	$Sprite2D.hide() #włącz animację
	$CollisionShape2D.disabled = true
	
	await get_tree().create_timer(2).timeout #usuń
	queue_free()

func _on_body_entered(body):
	if body.name == "player":
		body.point_count += 1
		call_deferred("destroy")
