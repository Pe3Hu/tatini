extends MarginContainer


#region vars
@onready var disasters = $Disasters

var planet = null
var influence = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	influence = 6
	refill_disasters()


func refill_disasters() -> void:
	for variation in Global.num.market.n:
		add_disaster(variation)


func add_disaster(variation_: int) -> void:
	var input = {}
	input.proprietor = self
	input.influence = influence + variation_
	roll_terrain_and_rank(input)

	var disaster = Global.scene.disaster.instantiate()
	disasters.add_child(disaster)
	disaster.set_attributes(input)


func roll_terrain_and_rank(input_) -> void:
	var options = Global.dict.terrain.influence[input_.influence]
	var description = options.pick_random()
	input_.terrain = description.terrain
	input_.rank = description.rank
#endregion

