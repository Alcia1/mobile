extends Sprite2D

func _ready():
	reset()

func _process(_delta):
	position.y += 1
	if position.y == 500:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0, 2)
		await tween.finished
		tween.kill()
		reset()

func reset():
	position.y = -648
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.3, 2)
	await tween.finished
	tween.kill()
