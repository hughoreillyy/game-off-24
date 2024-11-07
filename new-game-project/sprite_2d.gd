extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@export var allowed: bool = true 
@export var active_bag: bool = false 

func _ready() -> void:
	allowed = bool(randf() < 0.3)  
	move()

#SET COLOURS based on guilT
#func _process(delta: float) -> void:
	#if allowed:  
		#modulate = Color(1, 0, 0)  
	#else:
		#modulate = Color(0, 1, 0)  

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next"):  
		move()

#despawn bags which are done / offscreen
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter":
		animation_player.play("idle")
		print("idle playing")
	
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
		else:  
			animation_player.play("denied")
			active_bag == false
	else:
		animation_player.play("enter")  # Play 'enter' animation or other logic
