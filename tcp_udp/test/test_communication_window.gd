extends Control

@onready var _send_button: Button = $SendButton
@onready var _method_select: OptionButton = $MethodSelect
@onready var _port_box: LineEdit = $PortBox
@onready var _ip_box: LineEdit = $IPBox

func _ready() -> void:
	_send_button.pressed.connect(_on_connect)

func _verify_inputs() -> bool:
	if not _port_box.text.is_valid_int():
		return false
	
	var _port: int = _port_box.text.to_int()
		
	if not _ip_box.text.is_valid_ip_address():
		return false
		
	if _method_select.text not in ["TCP", "UDP"]:
		return false
	
	return true

func _on_connect() -> void:
	if not _verify_inputs():
		print("Cannot connect yet : inputs invalid")
		return

	match _method_select.text:
		"TCP":
			var _tcp_sock: StreamPeerTCP = StreamPeerTCP.new()
			var err: Error = _tcp_sock.connect_to_host(_ip_box.text, _port_box.text.to_int())
			
			if err:
				printerr("Error opening tcp socket (", error_string(err), ")")
				return

			_tcp_sock.disconnect_from_host()
		
		"UDP":
			var _udp_sock: PacketPeerUDP = PacketPeerUDP.new()
			var err: Error = _udp_sock.connect_to_host(_ip_box.text, _port_box.text.to_int())
			
			if err:
				printerr("Error opening udp socket (", error_string(err), ")")
				return
			
			_udp_sock.close()
		_:
			print("Error, invalid protocol")