extends Node

var saveDataCampaign = {
	
}

var saveDataEndless = {
	"high_score": 0,
	"distance_travelled": 0,
	"enemies_defeated": 0,
	"time_played": 0
}

var saveDataSettings = {
	
}

func saveEndless(score, distance, enemies):
	if score > saveDataEndless["high_score"]:
		saveDataEndless["high_score"] = score
	
	saveDataEndless["distance_travelled"] += distance
	saveDataEndless["enemies_defeated"] += enemies
