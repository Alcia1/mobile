extends TextureButton

func _on_pressed():
	if $Label.text == "mute":
		SaveGame.saveSettings(0, SaveGame.saveDataSettings["sfx"])
	else:
		SaveGame.saveSettings(1, SaveGame.saveDataSettings["sfx"])
	
	get_tree().root.get_node("MainMenu").changeMusic()
