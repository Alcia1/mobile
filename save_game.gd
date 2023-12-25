extends Node

#pozmieniac max score
var saveDataCampaign = {
	"1" = {
		"max_score": 1300,
		"high_score": 0
	},
	"2" = {
		"max_score": 2200,
		"high_score": 0
	},
	"3" = {
		"max_score": 2300,
		"high_score": 0
	},
	"4" = {
		"max_score": 3200,
		"high_score": 0
	},
	"5" = {
		"max_score": 2600,
		"high_score": 0
	},
	"6" = {
		"max_score": 2300,
		"high_score": 0
	},
	"7" = {
		"max_score": 2300,
		"high_score": 0
	},
	"8" = {
		"max_score": 3600,
		"high_score": 0
	}
}

var saveDataEndless = {
	"high_score": 0,
	"distance_traveled": 0,
	"enemies_defeated": 0,
	"time_played": 0
}

var saveDataSettings = {
	"music" = 1,
	"sfx" = 1
}

func resetSave():
	for i in saveDataCampaign:
		saveDataCampaign[i]["high_score"] = 0
	
	saveDataEndless["high_score"] = 0
	saveDataEndless["distance_traveled"] = 0
	saveDataEndless["enemies_defeated"] = 0
	saveDataEndless["time_played"] = 0
	
	var saveFile = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	saveFile.close()
	DirAccess.remove_absolute("user://savegame.save")
	
	saveToFile()
	loadFromFile()

func saveCampaign(level, score):
	if score > saveDataCampaign[str(level)]["high_score"]:
		saveDataCampaign[str(level)]["high_score"] = score
	
	saveToFile()

func saveEndless(score, distance, enemies, time):
	if score > saveDataEndless["high_score"]:
		saveDataEndless["high_score"] = score
	
	saveDataEndless["distance_traveled"] += distance
	saveDataEndless["enemies_defeated"] += enemies
	saveDataEndless["time_played"] += time
	
	saveToFile()

func saveSettings(music, sfx):
	saveDataSettings["music"] = music
	saveDataSettings["sfx"] = sfx
	
	saveToFile()

func saveToFile():
	var saveFile = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	saveFile.store_line("saveDataCampaign")
	for i in saveDataCampaign:
		print(i)
		print(str(saveDataCampaign[i]["max_score"]))
		saveFile.store_line(i)
		saveFile.store_line("max_score")
		saveFile.store_line(str(saveDataCampaign[i]["max_score"]))
		saveFile.store_line("high_score")
		saveFile.store_line(str(saveDataCampaign[i]["high_score"]))
	
	saveFile.store_line("saveDataEndless")
	saveFile.store_line("high_score")
	saveFile.store_line(str(saveDataEndless["high_score"]))
	saveFile.store_line("distance_traveled")
	saveFile.store_line(str(saveDataEndless["distance_traveled"]))
	saveFile.store_line("enemies_defeated")
	saveFile.store_line(str(saveDataEndless["enemies_defeated"]))
	saveFile.store_line("time_played")
	saveFile.store_line(str(saveDataEndless["time_played"]))

	saveFile.store_line("saveDataSettings")
	saveFile.store_line("music")
	saveFile.store_line(str(saveDataSettings["music"]))
	saveFile.store_line("sfx")
	saveFile.store_line(str(saveDataSettings["sfx"]))

	saveFile.close()

func loadFromFile():
	if not FileAccess.file_exists("user://savegame.save"):
		saveToFile()
	
	var saveFile = FileAccess.open("user://savegame.save", FileAccess.READ)
	var dictName = ""
	var key = ""
	var campaignLevel = ""
	var campaignKey = ""
	var settingsKey = ""
	while !saveFile.eof_reached():
		var line = saveFile.get_line()
		if dictName == "" or line == "saveDataEndless" or line == "saveDataCampaign" or line == "saveDataSettings":
			dictName = line
		else:
			match dictName:
				"saveDataEndless":
					if key == "":
						key = line
					else:
						saveDataEndless[key] = int(line)
						key = ""
				"saveDataCampaign":
					if campaignLevel == "":
						campaignLevel = line
					else:
						if campaignKey == "":
							campaignKey = line
						else:
							saveDataCampaign[campaignLevel][campaignKey] = int(line)
							
							if campaignKey == "high_score":
								campaignLevel = ""
							
							campaignKey = ""
							
				"saveDataSettings":
					if settingsKey == "":
						settingsKey = line
					else:
						saveDataSettings[settingsKey] = int(line)
						print(settingsKey + " " + line)
						settingsKey = ""
				_:
					pass
	saveFile.close()
