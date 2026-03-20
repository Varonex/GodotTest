class_name RPCEntity extends Node

# CONSTANTS

const ADDRESS: String = "127.0.0.1"
const PORT: int = 9111
const MAX_CLIENTS: int = 2

# VARIABLES

var _peers: Array[int] = []

@export var _timer: Timer

# ENGINE

func _ready() -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	if "--is-server" in OS.get_cmdline_args():
		peer.create_server(PORT, MAX_CLIENTS)
		
	else:
		peer.create_client(ADDRESS, PORT)
	
	multiplayer.multiplayer_peer = peer
	
	output("Created peer (id = %d)" % multiplayer.get_unique_id())
	_timer.timeout.connect(_on_timeout)

# METHODS

func output(msg: String) -> void:
	var prefix: String = "SERVER" if multiplayer.is_server() else "CLIENT"
	
	print("[%s - %d]: %s" % [prefix, multiplayer.get_unique_id(), msg])

func rpc_all() -> void:
	output("Can be called by anyone (id = %d)" % multiplayer.get_remote_sender_id())

func rpc_server() -> void:
	output("Can only be invoked by the server (id = %d = 1)" % multiplayer.get_remote_sender_id())

# CALLBACKS

func _on_timeout() -> void:
	if _peers.size() == 0:
		return
	
	# Call both methods.
	rpc_all.rpc()
	
	if (multiplayer.is_server()):
		rpc_server.rpc()

func _on_peer_connected(id: int) -> void:
	output("A peer connected (id = %d)" % id)
	
	if not _peers.has(id):
		_peers.append(id)

func _on_peer_disconnected(id: int) -> void:
	output("A peer disconnected (id = %d)" % id)
	
	_peers.remove_at(_peers.find(id))