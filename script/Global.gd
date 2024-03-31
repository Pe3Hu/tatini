extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()
	init_font()


func init_arr() -> void:
	arr.resource = ["gold", "power"]
	arr.indicator = ["health"]
	arr.restriction = ["side", "height", "extreme", "criterion"]


func init_num() -> void:
	num.index = {}
	num.index.card = 0
	
	num.dominion = {}
	num.dominion.n = 12
	
	num.terrain = {}
	num.terrain.rank = 4
	
	num.market = {}
	num.market.n = 3


func init_dict() -> void:
	init_neighbor()
	init_card()
	init_season()
	init_area()
	
	init_terrain()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_card() -> void:
	dict.card = {}
	dict.card.type = {}
	dict.card.type["gold"] = {}
	dict.card.type["gold"][1] = 8
	
	dict.card.type["power"] = {}
	dict.card.type["power"][1] = 2
	
	dict.acronym = {}
	dict.acronym["e"] = "enlarge"
	dict.acronym["d"] = "diminish"
	dict.acronym["r"] = "repeat"
	dict.acronym["s"] = "skip"


func init_season() -> void:
	dict.season = {}
	dict.season.phase = {}
	dict.season.phase["spring"] = ["incoming"]
	dict.season.phase["summer"] = ["selecting", "outcoming"]
	dict.season.phase["autumn"] = ["wounding"]
	dict.season.phase["winter"] = ["wilting", "sowing"]


func init_area() -> void:
	dict.area = {}
	dict.area.next = {}
	dict.area.next[null] = "discharged"
	dict.area.next["discharged"] = "available"
	dict.area.next["available"] = "hand"
	dict.area.next["hand"] = "discharged"
	dict.area.next["broken"] = "discharged"
	
	dict.area.prior = {}
	dict.area.prior["available"] = "discharged"
	dict.area.prior["hand"] = "available"


func init_terrain() -> void:
	dict.terrain = {}
	dict.terrain.title = {}
	dict.terrain.influence = {}
	dict.terrain.biome = {}
	
	var path = "res://asset/json/tatini_terrain.json"
	var array = load_data(path)
	var exceptions = ["title"]
	
	
	for terrain in array:
		var data = {}
		data.pattern = {}
		
		for key in terrain:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if words.size() > 1:
					var pattern = terrain[key].split(",")
					data.pattern[words[0]] = pattern 
				else:
					data[key] = terrain[key]
		
		dict.terrain.title[terrain.title] = data
		
		if !dict.terrain.biome.has(terrain.biome):
			dict.terrain.biome[terrain.biome] = []
		
		dict.terrain.biome[terrain.biome].append(terrain.title)
	
	exceptions = ["canyon", "rock", "bush"]
	
	for terrain in dict.terrain.title:
		var description = dict.terrain.title[terrain]
		
		for _i in range(1, num.terrain.rank + 1):
			var data = {}
			data.terrain = terrain
			data.rank = _i
			var influence = description.value + description.rank * (_i - 1)
			data.values = [int(influence)]
			
			for order in description.pattern:
				var k = description.count + _i - 1
				
				if terrain == "rock":
					k = 1
				
				for _j in k:
					for acronym in description.pattern[order]:
						var designation = dict.acronym[acronym]
						var value = int(data.values.back())
						
						if exceptions.has(terrain):
							var index = data.values.size() - 2
							value = int(data.values[index])
						
						match designation:
							"enlarge":
								value += 1
							"diminish":
								value -= 1
							"skip":
								value = 0
						
						data.values.append(value)
						influence += value
			
			influence = int(influence)
			
			if data.values.size() <= num.dominion.n:
				if !dict.terrain.influence.has(influence):
					dict.terrain.influence[influence] = []
				
				dict.terrain.influence[influence].append(data)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	
	scene.card = load("res://scene/3/card.tscn")
	
	scene.zone = load("res://scene/4/zone.tscn")
	
	scene.disaster = load("res://scene/5/disaster.tscn")
	
	


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	
	vec.size.token = Vector2(32, 32)
	vec.size.card = {}
	vec.size.card.market = Vector2(vec.size.token.x * 2, vec.size.token.y)
	vec.size.card.gameboard = Vector2(vec.size.token.x, vec.size.token.y)
	vec.size.bar = Vector2(128, 16)
	vec.size.gameboard = Vector2(vec.size.token.x * 6, vec.size.token.y * 5)
	vec.size.restriction = vec.size.token * 2
	vec.size.resource = vec.size.token * 1.75
	
	vec.size.zone = {}
	vec.size.zone.top = Vector2(vec.size.token.x, vec.size.token.y* 3)
	vec.size.zone.bottom = Vector2(vec.size.token.x, vec.size.token.y * 3)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.card = {}
	color.card.selected = {}
	color.card.selected[true] = Color.from_hsv(160 / h, 0.4, 0.7)
	color.card.selected[false] = Color.from_hsv(60 / h, 0.2, 0.9)
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0 / h, 0.9, 0.7)
	color.indicator.health.background = Color.from_hsv(0 / h, 0.5, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(270 / h, 0.9, 0.7)
	color.indicator.endurance.background = Color.from_hsv(270 / h, 0.5, 0.9)


func init_font():
	dict.font = {}
	dict.font.size = {}
	dict.font.size["resource"] = 24
	dict.font.size["card"] = 18
	dict.font.size["terrain"] = 18
	dict.font.size["season"] = 18
	dict.font.size["phase"] = 18
	dict.font.size["moon"] = 18
	dict.font.size["restriction"] = 18
	dict.font.size["index"] = 18
	dict.font.size["influence"] = 18


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func get_all_constituents_based_on_limit(array_: Array, limit_: int) -> Dictionary:
	var constituents = {}
	constituents[0] = []
	constituents[1] = []
	
	for child in array_:
		constituents[0].append(child)
		
		if child.value <= limit_:
			constituents[1].append([child])
	
	for _i in array_.size()-2:
		set_constituents_based_on_size_and_limit(constituents, _i+2, limit_)
	
	var value = 0
	
	for constituent in array_:
		value += constituent.value
	
	if value <= limit_:
		constituents[array_.size()] = [constituents[0]]
	
	constituents.erase(0)
	
	for _i in range(constituents.keys().size()-1,-1,-1):
		var key = constituents.keys()[_i]
		
		if constituents[key].is_empty():
			constituents.erase(key)
	
	return constituents


func set_constituents_based_on_size_and_limit(constituents_: Dictionary, size_:int, limit_: int) -> void:
	var parents = constituents_[size_-1]
	constituents_[size_] = []
	
	for parent in parents:
		var value = 0
		
		for constituent in parent:
			value += constituent.value
		
		for child in constituents_[0]:
			if !parent.has(child) and value + child.value <= limit_:
				var constituent = []
				constituent.append_array(parent)
				constituent.append(child)
				constituent.sort_custom(func(a, b): return constituents_[0].find(a) < constituents_[0].find(b))
				
				if !constituents_[size_].has(constituent):
					constituents_[size_].append(constituent)
