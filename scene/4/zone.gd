extends MarginContainer


#region vars
@onready var top = $VBox/Top
@onready var middle = $VBox/Middle
@onready var bottom = $VBox/Bottom
@onready var terrains = $VBox/Top/Terrains
@onready var influence = $VBox/Middle/VBox/Influence
@onready var index = $VBox/Middle/VBox/Index
@onready var tags = $VBox/Bottom/Tags


var dominion = null
var anchor = false
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	dominion = input_.dominion
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	top.custom_minimum_size = Global.vec.size.zone.top
	bottom.custom_minimum_size = Global.vec.size.zone.bottom
	init_tokens(input_)


func init_tokens(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "influence"
	input.subtype = "inactive"
	input.value = 0
	influence.set_attributes(input)
	
	input.type = "index"
	input.subtype = "inactive"
	input.value = input_.index
	index.set_attributes(input)


func set_as_anchor(anchor_: bool) -> void:
	anchor = anchor_
	var status = ""
	
	if !anchor:
		status = "in"
	
	status += "active"
	
	index.set_subtype(status)
	
	for _i in dominion.scope:
		var _j = _i + get_index()
		var zone = dominion.zones.get_child(_j)
		zone.influence.set_subtype(status)
#endregion
