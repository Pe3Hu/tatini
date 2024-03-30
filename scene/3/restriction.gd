extends MarginContainer


#region vars
@onready var side = $Side
@onready var extreme = $Extreme
@onready var criterion = $Criterion
@onready var height = $Height

var card = null
var planet = null
var opponents = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	card = input_.card
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Global.vec.size.restriction
	init_tokens(input_)


func init_tokens(input_: Dictionary) -> void:
	for data in input_.restrictions:
		var token = get(data.type)
		var input = {}
		input.proprietor = self
		input.type = "restriction"
		input.subtype = data.subtype
	
		if data.has("value"):
			input.value = data.value
		
		token.set_attributes(input)
