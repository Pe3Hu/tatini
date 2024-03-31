extends MarginContainer


#region vars
@onready var influences = $Influences

var card = null
var influence = null
var scope = 3
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	card = input_.card
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_influences(input_)


func init_influences(input_: Dictionary) -> void:
	for value in input_.values:
		var input = {}
		input.proprietor = self
		input.type = "terrain"
		input.subtype = card.terrain.subtype
		input.value = value
	
		var token = Global.scene.token.instantiate()
		influences.add_child(token)
		token.set_attributes(input)
		
		if value == 0:
			token.hide_tokens()
#endregion
