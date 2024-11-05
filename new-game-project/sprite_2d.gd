extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_guilty: bool = true 


func _ready() -> void:
	is_guilty = bool(randf() < 0.3)  
	
func _process(delta: float) -> void:
	if is_guilty:  
		modulate = Color(1, 0, 0)  
	else:
		modulate = Color(0, 1, 0)  


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next"):  
		if animation_player.current_animation == "idle":
			if is_guilty:  
				animation_player.play("denied")
			else:  
				animation_player.play("accepted")
		else:
			animation_player.play("enter")  # Play 'enter' animation or other logic

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter":
		animation_player.play("idle")
		print("idle playing")
	
	if anim_name == "denied":
		queue_free()
	
	if anim_name == "accepted":
		queue_free()


func move() -> void:
	print("move func received")
