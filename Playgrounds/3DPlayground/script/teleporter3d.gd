extends Area3D

# VARIABLES

## Target to teleport to.
@export var target: Node3D

## If the teleportation keeps X.
@export var keep_x: bool = false

## If the teleportation keeps Y.
@export var keep_y: bool = false

## If the teleportation keeps Z.
@export var keep_z: bool = false

## Offset to which one should teleport.
@export var offset: Vector3

## Groups to whitelist.
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

func _on_body_entered(body: Node3D) -> void:

	if whitelist_groups.size() == 0 or _is_in_whitelist(body):
		var t: Transform3D = body.global_transform
		
		t.origin = Vector3(
				(body if keep_x else target).global_position.x,
				(body if keep_y else target).global_position.y,
				(body if keep_z else target).global_position.z
		) + offset
		
		body.set_deferred(&"global_transform", t)