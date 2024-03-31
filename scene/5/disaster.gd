extends MarginContainer


#region vars
@onready var bg = $BG
@onready var rank = $VBox/HBox/VBox/Rank
@onready var terrain = $VBox/HBox/VBox/Terrain
@onready var cost = $VBox/HBox/VBox/Cost
@onready var restriction = $VBox/HBox/Restriction
@onready var landscape = $VBox/Landscape

var proprietor = null
var selected = false
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	#custom_minimum_size = Global.vec.size.card.market
	init_tokens(input_)
	#roll_restriction()
	init_landscape()
	init_bg()


func init_tokens(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "terrain"
	input.subtype = input_.terrain
	terrain.set_attributes(input)
	
	input.type = "card"
	input.subtype = "rank"
	input.value = input_.rank
	rank.set_attributes(input)
	
	#input.subtype = "cost"
	#input.value = rank.get_value()
	#cost.set_attributes(input)


func roll_restriction() -> void:
	var input = {}
	input.card = self
	input.restrictions = []
	
	var weights = {}
	weights.side = {}
	weights.side["left"] = 3
	weights.side["middle"] = 2
	weights.side["right"] = 3
	weights.extreme = {}
	weights.extreme["maximum"] = 1
	weights.extreme["random"] = 3
	weights.extreme["minimum"] = 1
	weights.height = {}
	weights.height["smaller"] = 1
	weights.height["equal"] = 3
	weights.height["larger"] = 1
	weights.height["none"] = 5
	weights.criterion = {}
	weights.criterion["remoteness"] = 1
	weights.criterion["height"] = 1
	weights.criterion["none"] = 8
	var middle = false
	var random = false
	
	for type in Global.arr.restriction:
		if !middle and !random:
			var data = {}
			data.type = type
			data.subtype = Global.get_random_key(weights[type])
			
			if data.type == "side" and data.subtype == "middle":
				middle = true
			
			if data.type == "extreme" and data.subtype == "random":
				random = true
			
			if data.subtype != "none":
				if data.type == "height":
					data.value = 1
				
				input.restrictions.append(data)
	
	restriction.set_attributes(input)



func init_landscape() -> void:
	var input = {}
	input.card = self
	
	for influence in Global.dict.terrain.influence:
		for description in Global.dict.terrain.influence[influence]:
			if description.terrain == terrain.subtype and description.rank == rank.get_value():
				input.values = description.values
				landscape.set_attributes(input)

func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func set_selected(selected_: bool) -> void:
	selected = selected_
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.card.selected[selected_]
#endregion
