extends Camera3D

# VARIABLES

## The movement speed of the camera.
@export var linear_speed: float = 16

## The angular speed of the camera.
@export var angular_speed: float = .002

## Linear damping.
@export var linear_damping: float = 5

## Angular damping.
@export var angular_damping: float = 5

var lock_mouse: bool = true:
	set(v):
		lock_mouse = v
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if v else Input.MOUSE_MODE_VISIBLE

var rot_x: float = 0
var rot_y: float = 0

var _target_pos: Vector3
var _target_basis: Basis

# ENGINE

func _ready() -> void:
	lock_mouse = lock_mouse
	_target_pos = global_position
	_target_basis = global_basis

func _process(delta: float) -> void:
	# Mouse lock.
	if Input.is_action_just_pressed(&"escape"):
		lock_mouse = not lock_mouse

	# Plan horizontal XZ.
	var horizontal_plane: Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward")
	
	# Axe vertical Y.
	var vertical_axis: float = Input.get_axis(&"down", &"up")
	
	# Shift linéaire.
	var linear_shift: Vector3 = Vector3(
					horizontal_plane.x,
					vertical_axis,
					horizontal_plane.y
			).normalized() * linear_speed * delta
	
	# Clamping pour éviter les dépassement sur y.
	rot_y = clampf(rot_y, deg_to_rad(-89), deg_to_rad(89))
	
	# On reconstruit la base initiale (sans shift).
	_target_basis = Basis.from_euler(Vector3(rot_y, rot_x, 0))
	
	# On accumule le shift au target en faisant un changement de base.
	_target_pos += _target_basis * linear_shift
	
	# On slerp.
	basis = basis.slerp(_target_basis, angular_damping * delta)
	
	# On lerp.
	global_position = global_position.lerp(_target_pos, linear_damping * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and lock_mouse:
		rot_x -= event.relative.x * angular_speed
		rot_y -= event.relative.y * angular_speed