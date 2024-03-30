extends MarginContainer


#region vars
@onready var available = $VBox/Cards/Available
@onready var discharged = $VBox/Cards/Discharged
@onready var broken = $VBox/Cards/Broken
@onready var hand = $VBox/Cards/Hand
@onready var storage = $VBox/Storage

var god = null
var capacity = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	input_.gameboard = self
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Global.vec.size.gameboard
	capacity.current = 6
	capacity.limit = 10
	
	var input = {}
	input.gameboard = self
	storage.set_attributes(input_)
	#init_starter_kit_cards()
	
	for key in Global.dict.area.next:
		if key != null:
			input_.type = key
			var cardstack = get(key)
			cardstack.set_attributes(input_)


func init_starter_kit_cards() -> void:
	for type in Global.dict.card.type:
		for value in Global.dict.card.type[type]:
			for _i in Global.dict.card.type[type][value]:
				var input = {}
				input.proprietor = self
				input.cost = 0
				input.resources = {}
				input.resources[type] = value
				input.area = "discharged"
			
				var card = Global.scene.card.instantiate()
				discharged.cards.add_child(card)
				card.set_attributes(input)
				card.set_gameboard_as_proprietor(self)
				#print([card.get_index(), suit, rank])
	
	#print("___")
	#reshuffle_available()
#endregion



func refill_hand() -> void:
	var cardstack = get(Global.dict.area.prior[hand.type])
	
	while hand.cards.get_child_count() < capacity.current:
		cardstack.advance_random_card()


func discard_hand() -> void:
	hand.advance_all_cards()


func fill_storage() -> void:
	for card in hand.cards.get_children():
		for resource in card.resources.get_children():
			storage.obtain_resource(resource)
