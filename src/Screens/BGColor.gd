extends ColorRect

func animate(visibility):
	var tween = get_tree().create_tween()
	
	if visibility == true:
		visible = visibility
		tween.tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await tween.finished
	else:
		tween.tween_property(self, "scale", Vector2(0,0), 0.1)
		await tween.finished
		visible = visibility
	
	tween.kill()
