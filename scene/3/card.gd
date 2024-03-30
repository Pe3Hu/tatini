extends MarginContainer


#region vars
@onready var bg = $BG
@onready var restriction = $HBox/Restriction

var proprietor = null
var area = null
var selected = false
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	area = input_.area
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	#custom_minimum_size = Global.vec.size.card.market
	roll_restriction()
	init_bg()


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
	
	for type in Global.arr.restriction:
		var data = {}
		data.type = type
		data.subtype = Global.get_random_key(weights[type])
		
		if data.subtype != "none":
			if data.type == "height":
				data.value = 1
			
			input.restrictions.append(data)
	
	restriction.set_attributes(input)


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func advance_area() -> void:
	var cardstack = null
	
	if area == null:
		area = Global.dict.area.next[area]
		advance_area()
	else:
		cardstack = proprietor.get(area)
		cardstack.cards.remove_child(self)
	
		area = Global.dict.area.next[area]
		cardstack = proprietor.get(area)
		cardstack.cards.add_child(self)


func set_gameboard_as_proprietor(gameboard_: MarginContainer) -> void:
	var cardstack = proprietor.get(area)
	var market = false
	
	if cardstack == null:
		cardstack = proprietor
		market = true
	
	cardstack.cards.remove_child(self)
	proprietor = gameboard_
	area = "discharged"
	
	cardstack = proprietor.get(area)
	cardstack.cards.add_child(self)
	
	custom_minimum_size = Global.vec.size.card.gameboard
	size = Global.vec.size.card.gameboard
	set_selected(false)
	
	if !market:
		advance_area()


func set_selected(selected_: bool) -> void:
	selected = selected_
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.card.selected[selected_]
#endregion
