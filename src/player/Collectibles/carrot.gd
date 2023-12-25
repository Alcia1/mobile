extends Node2D

var sfx_disabled = false

func _ready():
	if SaveGame.saveDataSettings["sfx"] == 0:
		sfx_disabled = true

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.point_count += 500
		get_child(1).set_deferred("monitoring", false)
		get_child(0).visible = false
		get_child(2).visible = true
		
		var tween = get_tree().create_tween()
		tween.tween_property(get_child(2), "position:y", -45, 0.5)
		if !sfx_disabled:
			$sfx.play()
		await $sfx.finished
		tween.kill()
		
		queue_free()
