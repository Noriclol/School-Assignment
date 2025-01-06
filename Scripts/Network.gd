extends Node


const DEFAULT_PORT = 7000
const MAX_CLIENTS = 10

var server = null
var client = null

var ip_adress = "localhost"


func _ready() -> void:
    # if OS.get_name() == "Windows":
    #     ip_adress = IP.get_local_addresses()[3]

    multiplayer.connected_to_server.connect(_connected_to_server)
    multiplayer.server_disconnected.connect(_server_disconnected)


func create_server()-> void:
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
    multiplayer.multiplayer_peer = peer
    get_window().title = "Host"
    pass


func create_client()-> void:
    var peer = ENetMultiplayerPeer.new()
    peer.create_client(ip_adress, DEFAULT_PORT)
    multiplayer.multiplayer_peer = peer
    get_window().title = "Client"
    pass


func _connected_to_server() -> void:
    print("Network module Connected to server")


func _server_disconnected() -> void:
    print("Server disconnected")