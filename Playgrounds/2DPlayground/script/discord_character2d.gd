extends CharacterBody2D

const JUMP_POWER: float = 400

func gravity2(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

func jump2() -> void:
	if Input.is_action_just_pressed(&"ui_accept") and is_on_floor():
		velocity.y = -JUMP_POWER

func _physics_process(delta: float) -> void:
	gravity2(delta)
	jump2()
	move_and_slide()
