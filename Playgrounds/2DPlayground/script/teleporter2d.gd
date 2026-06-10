extends Area2D

# VARIABLES

## Target to teleport to.
@export var target: Node2D

## If the teleportation keeps X.
@export var keep_x: bool = false

## If the teleportation keeps Y.
@export var keep_y: bool = false

## Offset to which one should teleport.
@export var offset: Vector2

## Group to whitelist.
@export var whitelist_groups: Array[StringName] = []

# METHODS

func _is_in_whitelist(node: Node) -> bool:
	for group: StringName in node.get_groups():
		if group in whitelist_groups:
			return true
	
	return false

# ENGINE

func _ready() -> void:
	body_entered.connect(_on_body_entered)

# CALLBACKS

func _on_body_entered(body: Node2D) -> void:

	if whitelist_groups.size() == 0 or _is_in_whitelist(body):
		var t: Transform2D = body.global_transform
		
		t.origin = Vector2(
				(body if keep_x else target).global_position.x,
				(body if keep_y else target).global_position.y
		) + offset
		
		body.set_deferred(&"global_transform", t)
