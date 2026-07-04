class_name LinkedList

# FIELDS

## First node in the list.
var first: LinkedListNode

## Last node in the list.
var last: LinkedListNode

## Size of the list.
var _size: int

# METHODS

## Appends the value to the list.
func append(value: Variant) -> LinkedListNode:
	var node: LinkedListNode = LinkedListNode.new(value)
	append_node(node)
	
	return node

## APpends the node to the list.
func append_node(node: LinkedListNode) -> void:
	# The list has a last (is not empty).
	if last:
		last.add_as_next(node)
	
	# The list is empty.
	else:
		first = node
		last = node

## Determines whether the list is empty.
func is_empty() -> bool:
	return _size == 0

## Get the node in position i.
func node_at(i: int) -> LinkedListNode:
	assert(i >= 0)
	
	if i > _size:
		return null
	
	var node: LinkedListNode = first
	while i > 0:
		node = node.next
		i -= 1
	
	return node

## Finds a node with the value.
func find(value: Variant) -> LinkedListNode:
	return find_filter(func(node: LinkedListNode): return value == node.value)
	
## Finds a node with the value with the same memory address.
func find_same(value: Variant) -> LinkedListNode:
	return find_filter(func(node: LinkedListNode): return is_same(value, node.value))

## Finds a node via a callable receiving the value as first parameter.
func find_filter(callback: Callable) -> LinkedListNode:
	if is_empty():
		return null
	
	var node: LinkedListNode = first
	var i: int = _size
	
	while i > 0 and not callback.call(node):
		node = node.next
		i -= 1
	
	return node

## Inserts the value at position i.
func insert(value, i) -> LinkedListNode:
	var node: LinkedListNode = node_at(i)
	
	if node:
		pass
	
	return null

## Inserts the node at position i.
func insert_node(node: LinkedListNode, i: int) -> void:
	pass

## Removes the node at position i.
func remove(i: int) -> LinkedListNode:
	return null

## Removes the last node.
func remove_last() -> LinkedListNode:
	return null

## Fetches the size.
func size() -> int:
	return _size

## Gets the value at position i.
func value_at(i: int) -> Variant:
	return null
