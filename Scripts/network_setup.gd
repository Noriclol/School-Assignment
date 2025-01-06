extends Control

var player = load("res://Scenes/Player.tscn")
var tank = load("res://Scenes/tank.tscn")


@onready var multiplayer_config_ui = %Multiplayer_Config
@onready var server_ip_adress = %Server_IP_Adress
@onready var device_ip_adress = %Device_IP_Adress
@onready var server_hud = %ServerHud


@onready var player_id : Label = %Player_Id
@onready var game_hud = %GameHud


@onready var multiplayer_spawner = %MultiplayerSpawner
@onready var spawned_scenes = %SpawnedScenes

@export var players : Array[Player] = []

func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)

	device_ip_adress.text = Network.ip_adress

@rpc
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")


func _on_create_server_pressed() -> void:
	multiplayer_config_ui.hide()
	Network.create_server()
	_instance_player(multiplayer.get_unique_id())
	if is_multiplayer_authority():
		server_hud.show()
	game_hud.show()
	player_id.text = "Player_" + str(multiplayer.get_unique_id())



func _on_join_server_pressed() -> void:
	if server_ip_adress.text != "":
		multiplayer_config_ui.hide()
		Network.ip_adress = server_ip_adress.text
		Network.create_client()
		game_hud.show()
		game_hud.show()
		player_id.text = "Player_" + str(multiplayer.get_unique_id())
		return


func _on_start_game_pressed() -> void:
	if is_multiplayer_authority():
		_start_game.rpc_id(1)
		server_hud.hide()
		game_hud.show()



func _player_connected(id) -> void:
	print("Player " + str(id) + " connected!")
	_instance_player(id)




func _player_disconnected(id) -> void:
	print("Player " + str(id) + " disconnected!")
	if spawned_scenes.has_node("Player_" + str(id)):
		spawned_scenes.get_node("Player_" + str(id)).queue_free()


func _connected_to_server() -> void:
	await get_tree().create_timer(0.01).timeout
	_instance_player(multiplayer.get_unique_id())
	print("Connected to server")


func _instance_player(id: int) -> void:
	var player_instance = Global.instance_node_at_location(player, spawned_scenes, Vector2.ZERO)
	player_instance.name = "Player_" + str(id)
	player_instance.set_multiplayer_authority(id)
	players.append(player_instance)


func _instance_tank(_player: Player) -> void:
	
	var random_offset = Vector2(randf_range(-500, 500), randf_range(-500, 500)) 
	_player.player_tank = Global.instance_node_at_location(tank, spawned_scenes, random_offset)
	_player.player_tank.set_multiplayer_authority(1)
	_player.player_tank.name = "Player_Tank_" + str(_player.multiplayer.get_unique_id())
	pass



@rpc("authority", "call_local", "reliable")
func _start_game() -> void:
	print("Starting game")
	for child in spawned_scenes.get_children():
		if child is Player:
			_instance_tank(child)
			
	# for player in player
	# 	player.spawn_tank
	pass
