extends Node2D

@onready var BagScene = preload("res://bag.tscn")
var current_bag: Node2D = null

#spawn the first bag on play
func _ready() -> void:
	spawn_bag()

##spawn 1 bag every time you press a button
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("next"):
		#spawn_bag()  

func spawn_bag() -> void:
	var bag = BagScene.instantiate()
	bag.position = Vector2(30, 100) 
	add_child(bag)
	print("spawned 1 bag") 
	current_bag = bag


func _on_button_guilty_pressed() -> void:
	current_bag.allowed = false
	current_bag.move()
	spawn_bag()
	
func _on_button_innocent_pressed() -> void:
	current_bag.allowed = true
	current_bag.move()
	spawn_bag()
