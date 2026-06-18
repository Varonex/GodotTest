class_name NamedGlobalClass

func _init(my_name: String) -> void:
	print("Global : ", my_name)

func _to_string() -> String:
	return "Global : /"

class Inner extends Resource:
	@export var my_var: int
	
	func _init(my_name: String) -> void:
		print("Inner : ", my_name)
		my_var = 5
	
	func _to_string() -> String:
		return str("Inner : ", my_var)