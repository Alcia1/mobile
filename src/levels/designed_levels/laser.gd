extends Area2D

var moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		position.y -= 90 * delta

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.call_deferred("hit")

func activate():
	moving = true
	monitoring = true
	visible = true
