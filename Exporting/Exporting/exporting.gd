@tool
extends Node

enum CustomEnum
{
	VALUE1 = 1, VALUE2 = 2
}

@export_category("Run")

@export_tool_button("Show types & values") var run_cmd: Callable = run

@export_category("I am a category")

@export_group("I'm the first group")

@export_subgroup("Only @export")

@export var Int: int
@export var Float: float
@export var Str: String
@export var Bool: bool
@export var MyNode: Node
@export var MyNodePath: NodePath
@export var MyStringName: StringName

@export var Vec2: Vector2
@export var Vec2i: Vector2i

@export var Vec3: Vector3
@export var Vec3i: Vector3i

@export var Arr: Array[Variant]
@export var TypedArr: Array[String]
@export var Packed: PackedByteArray

@export var Dict: Dictionary[Variant, Variant]
@export var TypedDictKeys: Dictionary[int, Variant]
@export var TypedDictValues: Dictionary[Variant, int]
@export var TypedDict: Dictionary[int, int]

@export var Enum: CustomEnum = CustomEnum.VALUE1

@export var ColorWithAlpha: Color

@export_subgroup("@export_* of different genres")

@export_enum("VALUE1:1", "VALUE2:2") var ExportedEnum: int

@export_color_no_alpha var ColorNoAlpha: Color

@export_dir var Directory: String
@export_global_dir var GlobalDirectory: String

@export_file var File: String
@export_file("*.png") var FilteredFile: String

@export_file_path var RawFile: String
@export_file_path("*.png") var FilteredRawFile: String

@export_global_file var GlobalFile: String
@export_global_file("*.png") var FilteredGlobalFile: String

@export_exp_easing var ExpEasing: float
@export_exp_easing("attenuation") var ExpEasingAttenuation: float
@export_exp_easing("positive_only") var ExpEasingPositiveOnly: float
@export_exp_easing("attenuation", "positive_only") var ExpEasingBoth: float

@export_flags("Fire:4", "Water:2", "Wind:8") var Flags: int
@export_flags_2d_navigation var NavigationFlags: int
@export_flags_2d_physics var PhysicsFlag: int
@export_flags_2d_render var RenderFlag: int
@export_flags_avoidance var AvoidanceFlag: int

@export_multiline var MultilineStr: String

@export_node_path("Node") var FilteredNodePath: NodePath

@export_placeholder("This is a placeholder") var PlaceholderString: String

@export_range(1, 3, 1) var RangeInt: int
@export_range(1, 3, .25) var RangeFloat: float
@export_range(1, 3, 1) var RangeArrayInt: Array[int]
@export_range(1, 3, .25) var RangeArrayFloat: Array[float]

@export_range(1, 3, 1, "or_greater") var RangeGoesBeyond: int
@export_range(1, 3, 1, "or_less") var RangeGoesBelow: int
@export_range(1, 16000, .25, "or_greater", "exp") var RangeGoesBeyondExponentially: float
@export_range(1, 3, .25, "radians_as_degrees") var RangeRadiansAsDegrees: float
@export_range(1, 3, 1, "suffix:m") var SuffixedRange: int

@export_storage var ValueStoredInFileButNotEditor: int

@export_tool_button("Hello I'm a button") var my_button: Callable = func(): print("Hi!")

@export_group("Group with prefixes", "test")

@export var test_one: int
@export var test_two: int
@export var test_three: int
@export var invalid_four: int

@export_group("Custom hints !")

# Activation/Désactivation d'un groupe
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var group_enable: bool

@export_custom(PROPERTY_HINT_EXPRESSION, "") var Expr: String
@export_custom(PROPERTY_HINT_LINK, "") var LinkedVecs: Vector3
@export_custom(PROPERTY_HINT_PASSWORD, "") var Password: String

func run() -> void:
	var properties: Array[Dictionary] = get_property_list()
	
	for property: Dictionary in properties:
		print(PropertyEntry.new(property))	


class PropertyEntry:
	var name: String
	var cname: StringName
	var type: int
	var hint: int
	var hint_string: String
	var usage: PropertyUsageFlags
	
	func _init(input: Dictionary) -> void:
		name = input.name
		cname = input.class_name
		type = input.type
		hint = input.hint
		hint_string = input.hint_string
		usage = input.usage
	
	func _to_string() -> String:
		if usage & PROPERTY_USAGE_CATEGORY:
			return "Category \"%s\"" % name
		
		elif usage & PROPERTY_USAGE_GROUP:
			return "Group \"%s\"" % name
			
		elif usage & PROPERTY_USAGE_SUBGROUP:
			return "Subgroup \"%s\"" % name
	
		return "Property \"%s\" of type \"%s\" (%s) has has property hint = %d with string = \"%s\" and usage = %d" \
			% [name, type_string(type), cname, hint, hint_string, usage]