extends MarginContainer


#region vars
@onready var zones = $Zones

var god = null
var zone = null
var scope = 3
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_zones()


func init_zones() -> void:
	for _i in Global.num.dominion.n:
		var input = {}
		input.dominion = self
		input.index = _i
	
		var _zone = Global.scene.zone.instantiate()
		zones.add_child(_zone)
		_zone.set_attributes(input)
	
	update_zone()


func update_zone() -> void:
	if zone == null:
		zone = zones.get_child(0)
		zone.set_as_anchor(true)
	else:
		zone.set_as_anchor(false)
		var index = (zone.get_index() + scope) % zones.get_child_count()
		zone = zones.get_child(index)
		zone.set_as_anchor(true)


#endregion
