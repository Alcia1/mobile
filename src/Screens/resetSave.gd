extends TextureButton

func _on_pressed():
	SaveGame.resetSave()
	get_parent().animate(false)
	get_tree().root.get_node("MainMenu").displayEndlessStats()
	get_tree().root.get_node("MainMenu").displayCampaignStats()
