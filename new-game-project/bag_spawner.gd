extends Node2D

@onready var BagScene = preload("res://bag.tscn")
var spawned_bags: Array = []
var current_bag: Node = null  # To keep track of the currently active bag

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next"):
		spawn_bag()  

func spawn_bag() -> void:
	var bag = BagScene.instantiate()
	bag.position = Vector2(100, 100) 
	add_child(bag)
	print("spawned 1 bag")
	spawned_bags.append(bag)  
	current_bag = bag  
