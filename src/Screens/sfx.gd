extends TextureButton

func _on_pressed():
	if $Label.text == "mute":
		SaveGame.saveSettings(SaveGame.saveDataSettings["music"], 0)
		$Label.text = "unmute"
	else:
		SaveGame.saveSettings(SaveGame.saveDataSettings["music"], 1)
		$Label.text = "mute"
	
