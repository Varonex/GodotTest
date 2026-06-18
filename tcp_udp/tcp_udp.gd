extends Node

const SELF_PORT: int = 35432

var _tcp_server: TCPServer = TCPServer.new()
var _udp_server: UDPServer = UDPServer.new()

var _tcp_valid: bool = false
var _udp_valid: bool = false

func _ready() -> void:
	var err: Error
	
	err = _tcp_server.listen(SELF_PORT)
	
	if err:
		printerr("Could not launch TCP (", error_string(err), ")")
	else:
		_tcp_valid = true
	
	err = _udp_server.listen(SELF_PORT)
	
	if err:
		printerr("Could not launch UDP (", error_string(err), ")")
	else:
		_udp_valid = true

func _process(_delta: float) -> void:
	# TCP
	while _tcp_valid and _tcp_server.is_connection_available():
		var sock: StreamPeerTCP = _tcp_server.take_connection()
		print("Received TCP from ", sock.get_connected_host(), ":", sock.get_connected_port())
		sock.disconnect_from_host()
	
	# UDP
	if _udp_valid:
		_udp_server.poll()
	
	while _udp_valid and _udp_server.is_connection_available():
		var sock: PacketPeerUDP = _udp_server.take_connection()
		print("Received UDP from ", sock.get_packet_ip(), ":", sock.get_packet_port())
		sock.close()
