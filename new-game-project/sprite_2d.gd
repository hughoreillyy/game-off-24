extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@export var allowed: bool = true 
@export var contraband_present: bool = false
@onready var BagNode = $Sprite2D/TextureRect  # Reference to the bag node

var timeout: bool = true

var guilty_sprites: Array = []
var innocent_sprites: Array = []
var random_item: Texture

func _ready() -> void:
	contraband_present = bool(randf() < 0.4)  
	move()
	var item_number = randf_range(4, 10)
	if contraband_present == true:
		preload_images("res://Art/Items_Guilty/", guilty_sprites)
		print("contraband present")

	preload_images("res://Art/Items_Innocent/", innocent_sprites)
	spawn_multiple_items(item_number)
 
# Image preloading for guilty and innocent items
func preload_images(folder_path: String, target_array: Array) -> void:
	var file_list = DirAccess.get_files_at(folder_path)
	for file_name in file_list:
		var extension := file_name.get_extension()
		if extension == "import" or extension == "remap":
			file_name = file_name.get_basename()
			extension = file_name.get_extension()
		if extension == "png":
			var sprite: Texture2D = load(folder_path.path_join(file_name))
			if sprite:
				target_array.append(sprite)  # Add the loaded image to the specific list

# Item spawning within the bag
func spawn_multiple_items(item_count: int) -> void:
	# Number of guilty items, either 1 or 2
	var guilty_item_count = int(randf_range(1, 3)) if contraband_present else 0
	var innocent_item_count = item_count - guilty_item_count
	# Spawn guilty items first, if any
	for i in range(guilty_item_count):
		spawn_item(guilty_sprites)
	# Spawn remaining innocent items
	for i in range(innocent_item_count):
		spawn_item(innocent_sprites)

func spawn_item(sprite_array: Array) -> void:
	# Define the maximum size for each item as a percentage of the bag size
	var max_item_size = BagNode.size * 0.3  
	var random_index = randi() % sprite_array.size()
	random_item = sprite_array[random_index]
	var sprite = Sprite2D.new()
	sprite.texture = random_item
	var original_size = sprite.texture.get_size()
	var scale_factor = min(max_item_size.x / original_size.x, max_item_size.y / original_size.y)
	sprite.scale = Vector2(scale_factor, scale_factor)
	sprite.rotation = randf_range(0,360)
	sprite.position = Vector2(
		randf_range(10, BagNode.size.x - sprite.texture.get_size().x * scale_factor - 10),
		randf_range(10, BagNode.size.y - sprite.texture.get_size().y * scale_factor - 10)
	)
	BagNode.add_child(sprite)

# Animation handling
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter":
		animation_player.play("idle")
		timeout = false
	
	if anim_name == "denied" or anim_name == "accepted":
		queue_free()

# Play animations and move the conveyor belt
func move() -> void:
	if animation_player.current_animation == "idle":
		if allowed:  
			animation_player.play("accepted")
			consequence()
		else:  
			animation_player.play("denied")
			consequence()
	else:
		animation_player.play("enter")

func consequence():
	#if contraband_present != allowed:

	#else:

	pass
