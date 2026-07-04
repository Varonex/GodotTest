class_name LinkedListNode extends Object

# FIELDS

## Next node in the list.
var next: LinkedListNode

## Previous node in the list.
var previous: LinkedListNode

## Value held by this node.
var value: Variant

# METHODS

## Add node as direct next and does node reassigning.
func add_as_next(node: LinkedListNode) -> void:
	# Next's previous becomes node.
	if next:
		next.previous = node
	
	# Node's previous becomes self and next is next.
	if node:
		node.previous = self
		node.next = next
	
	# Self's next becomes node.
	next = node

## Add node as direct previous and does node reassigning.
func add_as_previous(node: LinkedListNode) -> void:
	# Previous's next becomes node.
	if previous:
		previous.next = node
	
	# Node's previous becomes previous and next is self.
	if node:
		node.previous = previous
		node.next = self
	
	# Self's previous becomes node.
	previous = node

## Removes the next node and does node reassigning.
func remove_next() -> LinkedListNode:
	# No next.
	if next == null:
		return null
	
	# Next's next's previous is now self.
	if next.next:
		next.next.previous = self
	
	# Self's next is now next.next
	var next_cache: LinkedListNode = next
	next = next.next
	
	# Next is no longer in the list.
	next_cache.previous = null
	next_cache.next = null
	
	return next_cache

## Removes the previous node and does node reassigning.
func remove_previous() -> LinkedListNode:
	# No previous.
	if previous == null:
		return null
	
	# Previous's previou's next is now self.
	if previous.previous:
		previous.previous.next = self
	
	# Self's previous is now previous.previous.
	var previous_cache: LinkedListNode = previous
	previous = previous.previous
	
	# Previous is no longer in the list.
	previous_cache.previous = null
	previous_cache.next = null
	
	return previous_cache

# ENGINE

@warning_ignore("shadowed_variable")
func _init(value: Variant, previous: LinkedListNode = null, next: LinkedListNode = null) -> void:
	self.value = value
	self.previous = previous
	self.next = next
