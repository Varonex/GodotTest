class_name Reflection extends Node

# ENGINE

func _ready() -> void:
	print("Scan of all customized classes")
	print("Internal classes may be scanned with ClassDB. Customized ones can be scanned with ProjectSettings & the Script class.")
	print("BEGINNING OF SCAN ===================\n\n")
	
	# Scans custom classes only
	var classes: Array[Dictionary] = ProjectSettings.get_global_class_list()

	# {base, class, icon, language, path}
	for class_info in classes:
		_scan_class(ClassDefinition.new(class_info))
		print()
	
	print("\n\nEND OF SCAN ====================")

# METHODS

func _scan_class(class_info: ClassDefinition) -> void:
	print("Found class \"%s\" (extends \"%s\") written in %s at \"%s\""
			% [class_info.class_ident, class_info.base, class_info.language, class_info.path]
	)
	
	# Script loading
	var script: Script = load(class_info.path)
		
	# Constants
	if not script.get_script_constant_map().is_empty():
	
		print("Loading constants ...")
		var constants: Dictionary = script.get_script_constant_map()
		for constant: String in constants:
			_scan_constant(ConstantDefinition.new(constant, constants[constant]))
		print()
	
	# Properties
	if script.get_script_property_list().size() > 1:
	
		print("Loading properties ...")
		for property: Dictionary in script.get_script_property_list():
			# Avoids invalid idents (which can happen. An array entry contains the gdscript ref)
			if not property.name.is_valid_ascii_identifier():
				continue

			_scan_property(PropertyDefinition.new(property))
		print()
		
	# Signals
	if not script.get_script_signal_list().is_empty():
	
		print("Loading signals ...")
		for sig: Dictionary in script.get_script_signal_list():
			_scan_method(MethodDefinition.new(sig), true)
		print()
	
	# Methods
	if not script.get_script_method_list().is_empty():
	
		print("Loading methods ...")
		for method: Dictionary in script.get_script_method_list():
			# Avoids generated methods (especially get/set-generated methods) and invalid method names
			if not method.name.is_valid_ascii_identifier():
				continue
			
			_scan_method(MethodDefinition.new(method))
		print()

func _scan_constant(constant_info: ConstantDefinition) -> void:
	print("Found constant \"%s\" with value \"%s\""
			% [constant_info.constant_ident, str(constant_info.value)]
	)

func _scan_property(property_info: PropertyDefinition, is_param: bool = false) -> void:
	print("%s \"%s\" of type \"%s\"%s"
			% [
				"Found property" if not is_param else "- with param",
				property_info.property_ident,
				type_string(property_info.type),
				(" (extends \"%s\")" % property_info.property_class) if property_info.property_class else ""
			]
	)

func _scan_method(method_info: MethodDefinition, is_signal: bool = false) -> void:
	var n_args: int = method_info.args.size()
	print("Found %s \"%s\" with %d parameter%s"
			% [
				"method" if not is_signal else "signal",
				method_info.method_ident,
				n_args,
				"s" if n_args != 1 else ""
			]
	)
	
	for arg: Dictionary in method_info.args:
		_scan_property(PropertyDefinition.new(arg), true)

# INNER

class ClassDefinition:
	# VARIABLES
	
	var base: String
	var class_ident: String
	var icon: String
	var language: String
	var path: String
	
	# CONSTRUCTOR
	
	func _init(info: Dictionary) -> void:
		base = info.base
		class_ident = info.class
		icon = info.icon
		language = info.language
		path = info.path

class ConstantDefinition:
	# VARIABLES
	
	var constant_ident: String
	var value: Variant
	
	# CONSTRUCTOR
	
	func _init(ident: String, val: Variant) -> void:
		constant_ident = ident
		value = val

class PropertyDefinition:
	# VARIABLES
	
	var property_ident: String
	var property_class: StringName
	var type: int
	var hint: PropertyHint
	var hint_string: String
	var usage: PropertyUsageFlags
	
	# CONSTRUCTOR
	
	func _init(info: Dictionary) -> void:
		property_ident = info.name
		property_class = info.class_name
		type = info.type
		hint = info.hint
		hint_string = info.hint_string
		usage = info.usage

class MethodDefinition:
	# VARIABLES
	
	var method_ident: String
	var args: Array
	var default_args: Array
	var flags: MethodFlags = METHOD_FLAGS_DEFAULT
	var id: int
	var return_type: Dictionary
	
	# CONSTRUCTOR
	
	func _init(info: Dictionary) -> void:
		method_ident = info.name
		args = info.args
		default_args = info.default_args
		flags = info.flags
		id = info.id
		return_type = info.return