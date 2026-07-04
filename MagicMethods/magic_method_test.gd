extends Node

var _var_entries: Array[Dictionary] = [
	{"name": "my_var", "type": TYPE_INT}
]

var _variables: Dictionary[StringName, Variant] = {
	"my_var": 1
}

func _get(property: StringName) -> Variant:
	return _variables.get(property)

func _get_property_list() -> Array[Dictionary]:
	return _var_entries

func _set(property: StringName, value: Variant) -> bool:
	if _variables.has(property):
		_variables[property] = value
		return true
	
	return false

func _ready() -> void:
	print(self.my_var)
	self.my_var = 5
	print(self.my_var)
