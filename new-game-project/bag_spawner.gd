extends Node2D

@onready var wage_text: Label = $Wage_Text
@onready var BagScene = preload("res://bag.tscn")

var current_bag: Node2D = null
var pay: int = 0

#spawn the first bag on play
func _ready() -> void:
	spawn_bag()
	wage_text.text = "Wages: $%s" % pay

func spawn_bag() -> void:
	var bag = BagScene.instantiate()
	bag.position = Vector2(30, 100) 
	add_child(bag)
	print("spawned 1 bag") 
	current_bag = bag


func _on_button_guilty_pressed() -> void:
	current_bag.allowed = false
	calculate_pay()
	current_bag.move()
	spawn_bag()
	
func _on_button_innocent_pressed() -> void:
	current_bag.allowed = true
	calculate_pay()
	current_bag.move()
	spawn_bag()
	
func calculate_pay() -> void:
	if current_bag.allowed == true and current_bag.contraband_present == false:
		pay += 10
	if current_bag.allowed == true and current_bag.contraband_present == true:
		pay -= 20
	if current_bag.allowed == false and current_bag.contraband_present == true:
		pay += 30
	if current_bag.allowed == false and current_bag.contraband_present == false:
		pay -= 50
	wage_text.text = "Wages: $%s" % pay
