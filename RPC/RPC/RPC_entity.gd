class_name RPCServer extends Node

const ADDRESS: String = "127.0.0.1"
const PORT: int = 9111
const MAX_CLIENT: int = 2

@export var timer: Timer

var peers: Array[int] = []

func _ready() -> void:
	# Creates the peer.
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

	# Callbacks assignments. Must be done before the rest!
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)

	# THEN connection
	# If started as server.
	if "--is-server" in OS.get_cmdline_args():
		peer.create_server(PORT, MAX_CLIENT)

	else:
		peer.create_client(ADDRESS, PORT)	

	# THEN assign so that the multiplayer peer is always available
	multiplayer.multiplayer_peer = peer
	
	output("Created peer (id = %d)" % multiplayer.get_unique_id())
	
	timer.timeout.connect(_timeout)

func _timeout() -> void:
	# Doesn't run if no peers are connected
	if peers.size() == 0: return
	
	# We call both methods from the current context
	rpc_all.rpc()
	
	# Only the server can RPC this method !
	if multiplayer.is_server():
		rpc_server.rpc()

func _peer_connected(id_: int) -> void:
	output("A peer connected (id = %d)" % id_)
	
	if not peers.has(id_):
		peers.append(id_)
	
func _peer_disconnected(id_: int) -> void:
	output("A peer disconnected (id = %d)" % id_)
	
	if peers.has(id_):
		peers.erase(id_)

func output(str_: String) -> void:
	var prefix: String = "SERVER" if multiplayer.is_server() else "CLIENT"
	
	print("[%s - %s]: %s" % [prefix, multiplayer.get_unique_id(), str_])
	
@rpc("any_peer", "call_remote", "unreliable_ordered")
func rpc_all() -> void:
	output("Can be called by anyone (id = %d >= 1)" % multiplayer.get_remote_sender_id())

@rpc("authority", "call_remote", "unreliable_ordered")
func rpc_server() -> void:
	output("Can only be invoked by the server (id = %d = 1)" % multiplayer.get_remote_sender_id())
