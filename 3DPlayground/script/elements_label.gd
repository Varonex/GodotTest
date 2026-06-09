extends Label

func _process(_delta: float) -> void:
	text = "Count : %d" % get_tree().get_node_count()