extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@export var allowed: bool = true 
@export var active_bag: bool = false 
@export var contraband_present: bool = false
@onready var BagNode = $Sprite2D/TextureRect  # Reference to the bag node
@onready var label: RichTextLabel = $RichTextLabel

var item_sprites: Array = []
var random_item: Texture


func _ready() -> void:
	contraband_present = bool(randf() < 0.3)  
	move()
	
	#color randomize for debug
	#if contraband_present:  
		#modulate = Color(1, 0, 0)  
	#else:
		#modulate = Color(0, 1, 0)  

	var item_number = randf_range(1,11)	
	if contraband_present == true:
		preload_images("res://Greybox/Items/Guilty/")
		spawn_multiple_items(item_number)
		print("contrabrand present")
	
	preload_images("res://Greybox/Items/Innocent/")

	spawn_multiple_items(item_number)
 
#image preload
func preload_images(folder_path: String) -> void:
	var file_list = DirAccess.get_files_at(folder_path)  # Gets list of files in folder

	for file_name in file_list:
		var extension := file_name.get_extension()

		# Skip files with certain extensions (like .import or .remap)
		if extension == "import" or extension == "remap":
			file_name = file_name.get_basename()
			extension = file_name.get_extension()

		# Only load PNG files
		if extension == "png":
			var sprite: Texture2D = load(folder_path.path_join(file_name))
			if sprite:
				item_sprites.append(sprite)  # Add the loaded image to the list
				# print("Preloaded:", file_name)
		print("Preload successful")

# item spawning within the bag
func spawn_multiple_items(item_count: int) -> void:
	if item_sprites.size() == 0:
		#print("No items to spawn!")
		return

	# Define the maximum size for each item as a percentage of the bag size
	var max_item_size = BagNode.size * 0.25  # 25% of bag size

	for i in range(item_count):
		var random_index = randi() % item_sprites.size()
		random_item = item_sprites[random_index]

		var sprite = Sprite2D.new()
		sprite.texture = random_item

		var original_size = sprite.texture.get_size()
		var scale_factor = min(max_item_size.x / original_size.x, max_item_size.y / original_size.y)
		sprite.scale = Vector2(scale_factor, scale_factor)
		sprite.rotation = randf()
		sprite.position = Vector2(
			randf_range(10, BagNode.size.x - sprite.texture.get_size().x * scale_factor - 10),
			randf_range(10, BagNode.size.y - sprite.texture.get_size().y * scale_factor - 10)
		)

		BagNode.add_child(sprite)
		#print("Spawned item:", random_item)


#despawn bags which are done / offscreen
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter":
		animation_player.play("idle")
		#print("idle playing")
	
	if anim_name == "denied":
		queue_free()
	
	if anim_name == "accepted":
		queue_free()

#play animations, move the conveyer belt?
func move() -> void:
	if animation_player.current_animation == "idle":
		active_bag == true
		if allowed:  
			animation_player.play("accepted")
			active_bag == false
			consequence()
		else:  
			animation_player.play("denied")
			active_bag == false
			consequence()
	else:
		animation_player.play("enter")  # Play 'enter' animation or other logic


func consequence():
	if contraband_present and allowed == false:
		label.append_text("Correct verdict")
		label.modulate = Color(0, 1, 0) 
		
	if contraband_present and allowed == true:
		label.append_text("Incorrect verdict")
		label.modulate = Color(1, 0, 0)  
		
	if contraband_present == false and allowed:
		label.append_text("Correct verdict")
		label.modulate = Color(0, 1, 0) 

	if contraband_present == false and allowed == false:
		label.append_text("Incorrect verdict")
		label.modulate = Color(1, 0, 0)  
		
